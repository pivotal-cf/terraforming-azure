locals {
  resource_group_name = "${var.env_name}"
}

resource "azurerm_resource_group" "pcf_resource_group" {
  name     = "${var.resource_group_name != "" ? var.resource_group_name : local.resource_group_name}"
  location = "${var.location}"
}
