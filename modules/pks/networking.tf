// Subnets for PKS
resource "azurerm_subnet" "pks" {
  name                 = "${var.env_id}-pks-subnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.network_name}"
  address_prefix       = "${local.pks_cidr}"
}

resource "azurerm_subnet" "pks_services" {
  name                 = "${var.env_id}-pks-services-subnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.network_name}"
  address_prefix       = "${local.pks_services_cidr}"
}
