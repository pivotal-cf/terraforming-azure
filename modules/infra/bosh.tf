resource random_string "bosh_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

resource "azurerm_storage_account" "bosh_root_storage_account" {
  name                     = "${random_string.bosh_storage_account_name.result}"
  resource_group_name      = "${data.azurerm_resource_group.pcf_resource_group.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.env_name}"
    account_for = "bosh"
  }
}

resource "azurerm_storage_container" "bosh_storage_container" {
  name                  = "bosh"
  depends_on            = ["azurerm_storage_account.bosh_root_storage_account"]
  resource_group_name   = "${data.azurerm_resource_group.pcf_resource_group.name}"
  storage_account_name  = "${azurerm_storage_account.bosh_root_storage_account.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "stemcell_storage_container" {
  name                  = "stemcell"
  depends_on            = ["azurerm_storage_account.bosh_root_storage_account"]
  resource_group_name   = "${data.azurerm_resource_group.pcf_resource_group.name}"
  storage_account_name  = "${azurerm_storage_account.bosh_root_storage_account.name}"
  container_access_type = "blob"
}

resource "azurerm_storage_table" "stemcells_storage_table" {
  name                 = "stemcells"
  resource_group_name  = "${data.azurerm_resource_group.pcf_resource_group.name}"
  storage_account_name = "${azurerm_storage_account.bosh_root_storage_account.name}"
}

output "bosh_root_storage_account" {
  value = "${azurerm_storage_account.bosh_root_storage_account.name}"
}
