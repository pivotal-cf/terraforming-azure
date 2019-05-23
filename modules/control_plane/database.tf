resource "azurerm_postgresql_server" "plane" {
  name                = "${local.name_prefix}-postgres"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  sku {
    name     = "B_Gen5_2"
    capacity = 2
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 10240
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "${var.postgres_username}"
  administrator_login_password = "${random_string.postgres_password.result}"
  version                      = "9.6"
  ssl_enforcement              = "Enabled"

  count = "${var.external_db ? 1 : 0}"
}

resource "azurerm_postgresql_firewall_rule" "plane" {
  name                = "${local.name_prefix}-postgres-firewall"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${element(azurerm_postgresql_server.plane.*.name, 0)}"

  # Note, these only refer to internal AZURE IPs and not external
  # access from anywhere. Please don't change them unless you know
  # what you are doing. See terraform docs for details

  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
  count            = "${var.external_db ? 1 : 0}"
}

resource "azurerm_postgresql_database" "atc" {
  resource_group_name = "${var.resource_group_name}"
  name                = "atc"

  server_name = "${azurerm_postgresql_server.plane.name}"
  charset     = "UTF8"
  collation   = "English_United States.1252"

  count = "${var.external_db ? 1 : 0}"
}

resource "azurerm_postgresql_database" "credhub" {
  resource_group_name = "${var.resource_group_name}"
  name                = "credhub"

  server_name = "${azurerm_postgresql_server.plane.name}"
  charset     = "UTF8"
  collation   = "English_United States.1252"

  depends_on = ["azurerm_postgresql_database.atc"]
  count      = "${var.external_db ? 1 : 0}"
}

resource "azurerm_postgresql_database" "uaa" {
  resource_group_name = "${var.resource_group_name}"
  name                = "uaa"

  server_name = "${azurerm_postgresql_server.plane.name}"
  charset     = "UTF8"
  collation   = "English_United States.1252"

  depends_on = ["azurerm_postgresql_database.credhub"]
  count      = "${var.external_db ? 1 : 0}"
}

resource "random_string" "postgres_password" {
  length  = 16
  special = false
}
