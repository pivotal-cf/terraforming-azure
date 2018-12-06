provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  environment     = "${var.cloud_name}"
}

terraform {
  required_version = "< 0.12.0"
}

locals {
  # ensure prefix is <= 10 chars
  storage_account_prefix = "${substr("${var.env_short_name}", 0, min(10, length(var.env_short_name)))}"
}

resource "random_string" "storage_account_suffix" {
  length = 4
  upper = false
  special = false
}

module "infra" {
  source = "../modules/infra"

  env_name                          = "${var.env_name}"
  location                          = "${var.location}"
  dns_subdomain                     = "${var.dns_subdomain}"
  dns_suffix                        = "${var.dns_suffix}"
  pcf_infrastructure_subnet         = "${var.pcf_infrastructure_subnet}"
  pcf_virtual_network_address_space = "${var.pcf_virtual_network_address_space}"
  storage_account_prefix            = "${local.storage_account_prefix}"
  storage_account_suffix            = "${random_string.storage_account_suffix.result}"  
}

module "certs" {
  source = "../modules/certs"

  env_name           = "${var.env_name}"
  dns_suffix         = "${var.dns_suffix}"
  ssl_ca_cert        = "${var.ssl_ca_cert}"
  ssl_ca_private_key = "${var.ssl_ca_private_key}"
}

module "ops_manager" {
  source = "../modules/ops_manager"

  env_name       = "${var.env_name}"
  location       = "${var.location}"

  vm_count               = "${var.ops_manager_vm ? 1 : 0}"
  ops_manager_image_uri  = "${var.ops_manager_image_uri}"
  ops_manager_vm_size    = "${var.ops_manager_vm_size}"
  ops_manager_private_ip = "${var.ops_manager_private_ip}"

  optional_ops_manager_image_uri = "${var.optional_ops_manager_image_uri}"

  resource_group_name = "${module.infra.resource_group_name}"
  dns_zone_name       = "${module.infra.dns_zone_name}"
  security_group_id   = "${module.infra.security_group_id}"
  subnet_id           = "${module.infra.infrastructure_subnet_id}"

  storage_account_prefix = "${local.storage_account_prefix}"
  storage_account_suffix = "${random_string.storage_account_suffix.result}"
}

module "pks" {
  source = "../modules/pks"

  env_id   = "${var.env_name}"
  location = "${var.location}"

  resource_group_cidr = "10.0.0.0/16"

  resource_group_name = "${module.infra.resource_group_name}"
  network_name        = "${module.infra.network_name}"
}
