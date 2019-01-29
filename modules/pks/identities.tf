data "azurerm_subscription" "primary" {}

resource "azurerm_role_definition" "pks_master_role" {
  name        = "${var.env_id}-pks-master-role"
  scope       = "${data.azurerm_subscription.primary.id}"
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = [
      "Microsoft.Network/*",
      "Microsoft.Compute/disks/*",
      "Microsoft.Compute/virtualMachines/write",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Storage/storageAccounts/*"
    ]
    not_actions = []
  }

  assignable_scopes = [
    "${data.azurerm_subscription.primary.id}/resourceGroups/${var.env_id}",
  ]
}

resource "azurerm_role_definition" "pks_worker_role" {
  name        = "${var.env_id}-pks-worker-role"
  scope       = "${data.azurerm_subscription.primary.id}"
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = [
      "Microsoft.Storage/storageAccounts/*"
    ]
    not_actions = []
  }

  assignable_scopes = [
    "${data.azurerm_subscription.primary.id}/resourceGroups/${var.env_id}",
  ]
}

resource "azurerm_user_assigned_identity" "pks_master_identity" {
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  name = "${var.env_id}-pks-master"
}

resource "azurerm_role_assignment" "master_role_assignemnt" {
  scope              = "${data.azurerm_subscription.primary.id}/resourceGroups/${var.env_id}"
  role_definition_id = "${azurerm_role_definition.pks_master_role.id}"
  principal_id       = "${azurerm_user_assigned_identity.pks_master_identity.principal_id}"
}

resource "azurerm_user_assigned_identity" "pks_worker_identity" {
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  name = "${var.env_id}-pks-worker"
}

resource "azurerm_role_assignment" "worker_role_assignemnt" {
  scope              = "${data.azurerm_subscription.primary.id}/resourceGroups/${var.env_id}"
  role_definition_id = "${azurerm_role_definition.pks_worker_role.id}"
  principal_id       = "${azurerm_user_assigned_identity.pks_worker_identity.principal_id}"
}

resource "azurerm_availability_set" "pks" {
  name                = "${var.env_id}-availability-set"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}
