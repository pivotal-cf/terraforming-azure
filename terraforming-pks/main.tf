terraform {
  required_version = "< 0.12.0"
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  environment     = "${var.cloud_name}"

  version = "~> 1.32"
}

module "infra" {
  source = "../modules/infra"

  env_name                          = "${var.env_name}"
  location                          = "${var.location}"
  dns_subdomain                     = "${var.dns_subdomain}"
  dns_suffix                        = "${var.dns_suffix}"
  pcf_infrastructure_subnet         = "${var.pcf_infrastructure_subnet}"
  pcf_virtual_network_address_space = "${var.pcf_virtual_network_address_space}"
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

  env_name = "${var.env_name}"
  location = "${var.location}"

  ops_manager_image_uri  = "${var.ops_manager_image_uri}"
  ops_manager_vm_size    = "${var.ops_manager_vm_size}"
  ops_manager_private_ip = "${var.ops_manager_private_ip}"

  optional_ops_manager_image_uri = "${var.optional_ops_manager_image_uri}"

  resource_group_name = "${module.infra.resource_group_name}"
  dns_zone_name       = "${module.infra.dns_zone_name}"
  security_group_id   = "${module.infra.security_group_id}"
  subnet_id           = "${module.infra.infrastructure_subnet_id}"
}

module "pks" {
  source = "../modules/pks"

  env_id   = "${var.env_name}"
  location = "${var.location}"

  resource_group_cidr = "10.0.0.0/16"

  resource_group_name                 = "${module.infra.resource_group_name}"
  network_name                        = "${module.infra.network_name}"
  bosh_deployed_vms_security_group_id = "${module.infra.bosh_deployed_vms_security_group_id}"
}

data "azurerm_subscription" "primary" {}

resource "azurerm_role_definition" "pks_master_role" {
  name        = "${var.env_name}-pks-master-role"
  scope       = "${data.azurerm_subscription.primary.id}"
  description = "This is a custom role created via Terraform"

  permissions {
    actions = [
      "Microsoft.Network/*",
      "Microsoft.Compute/disks/*",
      "Microsoft.Compute/virtualMachines/write",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Storage/storageAccounts/*"
    ]
    not_actions = []
  }

  assignable_scopes = [
    "${data.azurerm_subscription.primary.id}/resourceGroups/${var.env_name}",
  ]
}

resource "azurerm_role_definition" "pks_worker_role" {
  name        = "${var.env_name}-pks-worker-role"
  scope       = "${data.azurerm_subscription.primary.id}"
  description = "This is a custom role created via Terraform"

  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Storage/storageAccounts/*"
    ]
    not_actions = []
  }

  assignable_scopes = [
    "${data.azurerm_subscription.primary.id}/resourceGroups/${var.env_name}",
  ]
}

resource "azurerm_user_assigned_identity" "pks_master_identity" {
  resource_group_name = "${module.infra.resource_group_name}"
  location            = "${var.location}"

  name = "pks-master"
}

resource "azurerm_role_assignment" "master_role_assignemnt" {
  scope              = "${data.azurerm_subscription.primary.id}/resourceGroups/${var.env_name}"
  role_definition_id = "${azurerm_role_definition.pks_master_role.id}"
  principal_id       = "${azurerm_user_assigned_identity.pks_master_identity.principal_id}"
}

resource "azurerm_user_assigned_identity" "pks_worker_identity" {
  resource_group_name = "${module.infra.resource_group_name}"
  location            = "${var.location}"

  name = "pks-worker"
}

resource "azurerm_role_assignment" "worker_role_assignemnt" {
  scope              = "${data.azurerm_subscription.primary.id}/resourceGroups/${var.env_name}"
  role_definition_id = "${azurerm_role_definition.pks_worker_role.id}"
  principal_id       = "${azurerm_user_assigned_identity.pks_worker_identity.principal_id}"
}

resource "azurerm_availability_set" "pks" {
  name                = "${var.env_name}-availability-set"
  location            = "${var.location}"
  resource_group_name = "${module.infra.resource_group_name}"
}
