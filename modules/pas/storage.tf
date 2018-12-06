# Storage containers to be used as CF Blobstore

resource "azurerm_storage_account" "cf_storage_account" {
  name                     = "${var.cf_storage_account_prefix}${var.cf_storage_account_name}${var.cf_storage_account_suffix}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "cf_buildpacks_storage_container" {
  name                  = "${var.cf_buildpacks_storage_container_name}"
  depends_on            = ["azurerm_storage_account.cf_storage_account"]
  resource_group_name   = "${var.resource_group_name}"
  storage_account_name  = "${azurerm_storage_account.cf_storage_account.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "cf_packages_storage_container" {
  name                  = "${var.cf_packages_storage_container_name}"
  depends_on            = ["azurerm_storage_account.cf_storage_account"]
  resource_group_name   = "${var.resource_group_name}"
  storage_account_name  = "${azurerm_storage_account.cf_storage_account.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "cf_droplets_storage_container" {
  name                  = "${var.cf_droplets_storage_container_name}"
  depends_on            = ["azurerm_storage_account.cf_storage_account"]
  resource_group_name   = "${var.resource_group_name}"
  storage_account_name  = "${azurerm_storage_account.cf_storage_account.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "cf_resources_storage_container" {
  name                  = "${var.cf_resources_storage_container_name}"
  depends_on            = ["azurerm_storage_account.cf_storage_account"]
  resource_group_name   = "${var.resource_group_name}"
  storage_account_name  = "${azurerm_storage_account.cf_storage_account.name}"
  container_access_type = "private"
}
