variable "vsphere_username" {}
variable "vsphere_password" {}

provider "vsphere" {
  user                  = "${var.vsphere_user}"
  password              = "${var.vsphere_password}"
  vsphere_server        = "${var.vsphere_server}"
  allow_unverified_ssl  = "${var.allow_unverified_ssl}"
}

resource "vsphere_folder" "devenv" {
  path = "${var.vsphere_folder}"
}

data "template_file" "vsphere_cloudinit" {
  template    = "${file("${path.module}/templates/vsphere_cloudinit.tpl"

  vars = {
    public_key = "${file.var.public_key}"
  }
}

resource "vsphere_virtual_machine" "devenv" {
  name                = "${var.vsphere_user}-devenv"
  folder              = "${vsphere_folder.devenv.path}"
  vcpu                = "${var.vcpu}"
  memory              = "${var.memory}"
  skip_customization  = "${var.skip_customization}"

  custom_configuration_parameters {
    cloudinit.userdata = "${data.template_file.vsphere_cloudinit.rendered}"
  }

  network_interface   = {
    label = "${var.vsphere_network}"
  }

  disk {
    template = "${var.vsphere.template}"
  }
}

data "template_file" "inventory" {
  depends_on = ["vsphere_virtual_machine.devenv"]
  template = "${file("${path.module}/templates/inventory.tpl"

  vars = {
    gpg_sign_key  = "${var.gpg_key}"
    email         = "${var.email}"
    private_key   = "${var.private_key}"
    public_ip     = "${vsphere_virtual_machine.devenv.network_interface.0.ipv4.address}"
    name          = "${vsphere_virtual_machine.devenv.name}"
    ansible_user  = "${var.ansible_user}"
    fullname      = "${var.fullname}"
  }
}
