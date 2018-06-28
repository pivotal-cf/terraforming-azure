variable "env_name" {}

variable "env_short_name" {
  description = "Used for creating storage accounts. Must be a-z only, no longer than 10 characters"
}

variable cf_storage_account_name {
  type        = "string"
  description = "storage account name for cf"
  default     = "cf"
}

variable cf_buildpacks_storage_container_name {
  type        = "string"
  description = "container name for cf buildpacks"
  default     = "buildpacks"
}

variable cf_packages_storage_container_name {
  type        = "string"
  description = "container name for cf packages"
  default     = "packages"
}

variable cf_droplets_storage_container_name {
  type        = "string"
  description = "container name for cf droplets"
  default     = "droplets"
}

variable cf_resources_storage_container_name {
  type        = "string"
  description = "container name for cf resources"
  default     = "resources"
}

variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "location" {}

variable "ssl_cert" {
  type        = "string"
  description = "the contents of an SSL certificate which should be passed to the gorouter, optional if `ssl_ca_cert` is provided"
  default     = ""
}

variable "ssl_private_key" {
  type        = "string"
  description = "the contents of an SSL private key which should be passed to the gorouter, optional if `ssl_ca_cert` is provided"
  default     = ""
}

variable "ssl_ca_cert" {
  type        = "string"
  description = "the contents of a CA public key to be used to sign a generated certificate for gorouter, optional if `ssl_cert` is provided"
  default     = ""
}

variable "ssl_ca_private_key" {
  type        = "string"
  description = "the contents of a CA private key to be used to sign a generated certificate for gorouter, optional if `ssl_cert` is provided"
  default     = ""
}

variable "ops_manager_image_uri" {}

variable "ops_manager_private_ip" {
  type        = "string"
  description = "IP for the Ops Manager instance if not deploying in the default management subnet"
  default     = "10.0.8.4"
}

variable "optional_ops_manager_image_uri" {
  default = ""
}

variable "ops_manager_vm_size" {
  type    = "string"
  default = "Standard_DS2_v2"
}

variable "dns_suffix" {}

variable "dns_subdomain" {
  "type"        = "string"
  "description" = "The base subdomain used for PCF. For example, if your dns_subdomain is `cf`, and your dns_suffix is `pivotal.io`, your PCF domain would be `cf.pivotal.io`"
  "default"     = ""
}

variable "isolation_segment" {
  default = false
}

variable "iso_seg_ssl_cert" {
  type        = "string"
  description = "the contents of an SSL certificate which should be passed to the iso seg gorouter, optional if `iso_seg_ssl_ca_cert` is provided"
  default     = ""
}

variable "iso_seg_ssl_private_key" {
  type        = "string"
  description = "the contents of an SSL private key which should be passed to the iso seg gorouter, optional if `iso_seg_ssl_ca_cert` is provided"
  default     = ""
}

variable "iso_seg_ssl_ca_cert" {
  type        = "string"
  description = "the contents of a CA public key to be used to sign a generated certificate for iso seg gorouter, optional if `iso_seg_ssl_cert` is provided"
  default     = ""
}

variable "iso_seg_ssl_ca_private_key" {
  type        = "string"
  description = "the contents of a CA private key to be used to sign a generated certificate for iso seg gorouter, optional if `iso_seg_ssl_cert` is provided"
  default     = ""
}

variable "pcf_virtual_network_address_space" {
  type    = "list"
  default = ["10.0.0.0/16"]
}

variable "pcf_management_subnet" {
  type    = "string"
  default = "10.0.8.0/26"
}

variable "pcf_pas_subnet" {
  type    = "string"
  default = "10.0.0.0/22"
}

variable "pcf_services_subnet" {
  type    = "string"
  default = "10.0.4.0/22"
}

variable "pcf_dynamic_services_subnet" {
  type    = "string"
  default = "10.0.12.0/22"
}
