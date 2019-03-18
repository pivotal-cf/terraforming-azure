# Required variables:

variable "client_id" {}

variable "client_secret" {}

variable "subscription_id" {}

variable "tenant_id" {}

variable "dns_suffix" {}

variable "env_name" {}

variable "location" {}

# Optional variables (the following have default values):

variable "cloud_name" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
}

variable "dns_subdomain" {
  "type"        = "string"
  "description" = "The base subdomain used for PCF. For example, if your dns_subdomain is `cf`, and your dns_suffix is `pivotal.io`, your PCF domain would be `cf.pivotal.io`"
  "default"     = ""
}

variable "ops_manager_image_uri" {
  default = ""
}

variable "ops_manager_private_ip" {
  type        = "string"
  description = "IP for the Ops Manager instance if not deploying in the default infrasstructure subnet"
  default     = "10.0.8.4"
}

variable "ops_manager_vm_size" {
  type    = "string"
  default = "Standard_DS2_v2"
}

variable "ops_manager_a_record" {
  type        = "string"
  description = "The A record to associate with the Ops Manager VM. For example, if your ops_manager_a_record is `pcf`, and your dns_suffix is `pivotal.io`, your Opsman domain would be `pcf.pivotal.io`"
  default     = "pcf"
}

variable "optional_ops_manager_image_uri" {
  default = ""
}

variable "pcf_infrastructure_subnet" {
  type    = "string"
  default = "10.0.8.0/26"
}

variable "pcf_virtual_network_address_space" {
  type    = "list"
  default = ["10.0.0.0/16"]
}

variable "plane_cidr" {
  default = "10.0.10.0/28"
}

variable "postgres_username" {
  default = "pgadmin"
}

variable "external_db" {
  default = false
}
