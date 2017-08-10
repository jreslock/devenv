provider "openstack" {
  user_name     = "${var.openstack_user_name}"
  tenant_id     = "${var.openstack_project_id}"
  password      = "${var.openstack_password}"
  auth_url      = "${var.openstack_auth_url}"
  domain_name   = "${var.openstack_domain_name}"
  insecure      = "${var.openstack_insecure}"
}

resource "openstack_compute_keypair_v2" "keypair" {
  region      = "${var.openstack_region}"
  name        = "${var.openstack_user_name}-keypair"
  public_key  = "${file(var.public_key)}"
}

resource "openstack_blockstorage_volume_v2" "storagevol" {
  name = "${var.openstack_user_name}-dev-vol"
  size = 100
}

resource "openstack_compute_instance_v2" "instance" {
  name            = "${var.openstack_user_name}-devenv"
  image_id        = "${var.openstack_image_id}"
  flavor_id       = "${var.openstack_flavor_id}"
  key_pair        = "${openstack_compute_keypair_v2.keypair.id}"
  security_groups = ["default"]

  network {
    name = "${var.openstack_net_name}"
  }
}

resource "openstack_compute_volume_attach_v2" "attach" {
  depends_on    = ["openstack_blockstorage_volume_v2.storagevol","openstack_compute_instance_v2.instance"]
  instance_id   = "${openstack_compute_instance_v2.instance.id}"
  volume_id     = "${openstack_blockstorage_volume_v2.storagevol.id}"
}

resource "openstack_networking_floatingip_v2" "float" {
  pool = "public1"
}

resource "openstack_compute_floatingip_associate_v2" "float_assoc" {
  depends_on  = ["openstack_compute_instance_v2.instance",
                 "openstack_networking_floatingip_v2.float",
                 "openstack_compute_volume_attach_v2.attach"
                ]
  floating_ip = "${openstack_networking_floatingip_v2.float.address}"
  instance_id = "${openstack_compute_instance_v2.instance.id}"
}

data "template_file" "inventory" {
  depends_on  = ["openstack_compute_floatingip_associate_v2.float_assoc"]
  template    = "${file("${path.module}/templates/inventory.tpl")}"

  vars {
    public_ip   = "${openstack_networking_floatingip_v2.float.address}"
    name        = "${openstack_compute_instance_v2.instance.name}"
    ansible_user= "${var.ansible_user}"
    fullname    = "${var.fullname}"
    gpg_key     = "${var.gpg_key}"
    email       = "${var.email}"
    private_key = "${var.private_key}"
  }
}

resource "null_resource" "wait" {
  depends_on = ["openstack_compute_floatingip_associate_v2.float_assoc"]
  provisioner "remote-exec" {
    inline = [
      "echo $(hostname -I | cut -d ' ' -f 1) $(hostname) | sudo tee -a /etc/hosts"
    ]
    connection {
      user = "${var.ansible_user}"
      host = "${openstack_networking_floatingip_v2.float.address}"
      private_key = "${file(var.private_key)}"
      timeout = "1m"
    }
  }
}

resource "null_resource" "write_inventory" {
  depends_on = ["data.template_file.inventory",
                "null_resource.wait"]
  provisioner "local-exec" {
    command = "cat << 'EOF' > /tmp/devenv-inventory\n${data.template_file.inventory.rendered}\nEOF"
  }
}

resource "null_resource" "ansible" {
  depends_on = ["null_resource.write_inventory"]
  provisioner "local-exec" {
    command = "ansible-playbook -i /tmp/devenv-inventory ${var.ansible_playbook_dir}/devenv.yml"
  }
}