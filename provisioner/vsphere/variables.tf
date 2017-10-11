variable "private_key" {
  type = "string"
  default = "~/.ssh/id_rsa"
}

variable "public_key" {
  type = "string"
  default = "~/.ssh/id_rsa.pub"
}

variable "skip_customization" {
  type = "string"
  default = "true"
}

variable "vsphere_server" {
  type = "string"
  default = ""
}

variable "vsphere_user_name" {
  type = "string"
  default = ""
}

variable "vsphere_password" {
  type = "string"
  default = ""
}

variable "allow_unverified_ssl" {
    type = "string"
    default = "true"
}

variable "vsphere_network" {
  type = "string"
  default = ""
}

variable "vsphere_folder" {
  type = "string"
  default = ""
}

variable "vcpu" {
  type = "string"
  default = "2"
}

variable "memory" {
  type = "string"
  default = "4096"
}

variable "fullname" {
  type = "string"
  default = ""
}

variable "gpg_key" {
  type = "string"
  default = ""
}

variable "email" {
  type = "string"
  default = ""
}

variable "ansible_playbook_dir" {
  type = "string"
  default = ""
}

variable "ansible_user" {
  type = "string"
  default = ""
}