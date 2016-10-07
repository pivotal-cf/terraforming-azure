variable "env_name" {}

variable "env_short_name" {
  description = "Used for creating storage accounts. Must be a-z only, no longer than 10 characters"
}

variable "base_storage_account_wildcard" {
  type        = "string"
  default     = "boshvms"
  description = "the CPI uses this as a wildcard to stripe disks across multiple storage accounts"
}

variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "location" {}

variable "ops_manager_image_uri" {}

variable "vm_admin_username" {}

variable "vm_admin_password" {}

variable "vm_admin_public_key" {}

variable "vm_admin_private_key" {}

variable "dns_suffix" {}
