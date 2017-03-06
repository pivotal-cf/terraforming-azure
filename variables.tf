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

variable "dns_suffix" {}

/*************************************
 * Optional Isolation Segment Config *
 *************************************/

variable "create_iso_seg_resources" {
  type        = "string"
  default     = "0"
  description = "Optionally create a LB and DNS entries for a single isolation segment. Valid values are 0 or 1."
}
