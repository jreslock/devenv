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
  floating_ip = "${openstack_networking_floatingip_v2.float.address}"
  instance_id = "${openstack_compute_instance_v2.instance.id}"
}