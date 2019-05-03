variable "subscription_id" {
  default = ""
}

variable "client_id" {
  default = ""
}

variable "client_secret" {
  default = ""
}

variable "tenant_id" {
  default = ""
}

variable "cloud_name" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
}

variable "env_name" {}

variable "location" {
  default = ""
}

variable "dns_suffix" {
  default = ""
}

variable "dns_subdomain" {
  "type"        = "string"
  "description" = "The base subdomain used for PCF. For example, if your dns_subdomain is `cf`, and your dns_suffix is `pivotal.io`, your PCF domain would be `cf.pivotal.io`"
  "default"     = ""
}

variable "pcf_infrastructure_subnet" {
  type    = "string"
  default = "10.0.8.0/26"
}

variable "pcf_virtual_network_address_space" {
  type    = "list"
  default = ["10.0.0.0/16"]
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

variable "ops_manager_vm_size" {
  type    = "string"
  default = "Standard_DS2_v2"
}

variable "ops_manager_private_ip" {
  type        = "string"
  description = "IP for the Ops Manager instance if not deploying in the default infrasstructure subnet"
  default     = "10.0.8.4"
}

variable "ops_manager_dns_name" {
  default = "pcf"
}

variable "optional_ops_manager_image_uri" {
  default = ""
}

variable "ssl_cert" {
  default = ""
}

variable "ssl_private_key" {
  default = ""
}

variable "azure_master_managed_identity" {
  type = "string"
  default = "pks-master"
}

variable "azure_worker_managed_identity" {
  type = "string"
  default = "pks-worker"
}
