variable "env_name" {}

variable "env_short_name" {
  description = "Used for creating storage accounts. Must be a-z only, no longer than 10 characters"
}

variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "location" {}

variable "ops_manager_image_uri" {}

variable "optional_ops_manager_image_uri" {
  default = ""
}

variable "vm_admin_username" {}

variable "vm_admin_password" {}

variable "vm_admin_public_key" {}

variable "vm_admin_private_key" {}

variable "dns_suffix" {}
