// Subnets for PKS
resource "azurerm_subnet" "pks" {
  name                 = "${var.env_id}-pks-subnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.network_name}"
  address_prefixes     = ["${local.pks_cidr}"]
}

resource "azurerm_subnet" "pks_services" {
  name                 = "${var.env_id}-pks-services-subnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.network_name}"
  address_prefixes     = ["${local.pks_services_cidr}"]
}

resource "azurerm_subnet_network_security_group_association" "pks_services" {
  subnet_id                 = "${azurerm_subnet.pks_services.id}"
  network_security_group_id = "${var.bosh_deployed_vms_security_group_id}"
}
