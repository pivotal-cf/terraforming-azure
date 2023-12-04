variable "env_name" {}

variable "cloud_name" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
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

variable "ops_manager_image_uri" {
  type        = "string"
  description = "Ops Manager image on Azure. Ops Manager VM will be skipped if this is empty"
}

variable "ops_manager_private_ip" {
  type        = "string"
  description = "IP for the Ops Manager instance if not deploying in the default infrasstructure subnet"
  default     = "10.0.8.4"
}

variable "optional_ops_manager_image_uri" {
  default = ""
}

variable "ops_manager_vm_size" {
  type    = "string"
  default = "Standard_DS2_v2"
}

variable "dns_suffix" {
}

variable "dns_subdomain" {
  type        = "string"
  description = "The base subdomain used for PCF. For example, if your dns_subdomain is `cf`, and your dns_suffix is `pivotal.io`, your PCF domain would be `cf.pivotal.io`"
  default     = ""
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

variable "pcf_infrastructure_subnet" {
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

variable "use_existing_rgs" {
  default = false
}

variable "pcf_vnet_rg" {
  default = ""
}

variable "pcf_vnet_name" {
  default = ""
}

variable "create_vnet" {
  default = true
}

variable "env_short_name" {}

variable "vm_admin_username" {
  default = "ubuntu"
}
