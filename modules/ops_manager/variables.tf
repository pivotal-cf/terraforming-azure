# ==================== Variables

variable "env_name" {
  default = ""
}

variable "location" {
  default = ""
}

variable "ops_manager_private_ip" {
  default = ""
}

variable "ops_manager_image_uri" {
  default = ""
}

variable "ops_manager_vm_size" {
  default = ""
}

variable "resource_group_name" {
  default = ""
}

variable "security_group_id" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

variable "dns_zone_name" {
  default = ""
}

variable "optional_ops_manager_image_uri" {
  default = ""
}

resource random_string "ops_manager_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

resource "tls_private_key" "ops_manager" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Deprecated - remove after next release

variable "vm_count" {}
