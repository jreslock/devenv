variable "private_key" {
  type = "string"
  default = "~/.ssh/id_rsa"
}

variable "public_key" {
  type = "string"
  default = "~/.ssh/id_rsa.pub"
}

variable "openstack_auth_url" {
  type = "string"
  default = ""
}

variable "openstack_user_name" {
  type = "string"
  default = ""
}

variable "openstack_password" {
  type = "string"
  default = ""
}

variable "openstack_domain_name" {
  type = "string"
  default = ""
}

variable "openstack_region" {
  type = "string"
  default = "RegionOne"
}

variable "openstack_project_id" {
  type = "string"
  default = ""
}

variable "openstack_insecure" {
  type = "string"
  default = "true"
}

variable "openstack_net_name" {
  type = "string"
  default = ""
}

variable "openstack_image_id" {
  type = "string"
  default = ""
}

variable "openstack_flavor_id" {
  type = "string"
  default = ""
}