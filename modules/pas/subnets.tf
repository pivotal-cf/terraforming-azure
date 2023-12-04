# ================================= Subnets ====================================

resource "azurerm_subnet" "pas_subnet" {
  name = "${var.env_name}-pas-subnet"

  //  depends_on                = ["${var.network_rg_name}"]
  resource_group_name       = "${var.network_rg_name}"
  virtual_network_name      = "${var.network_name}"
  address_prefix            = "${var.pas_subnet_cidr}"
  network_security_group_id = "${var.bosh_deployed_vms_security_group_id}"
}

resource "azurerm_subnet_network_security_group_association" "pas_subnet" {
  subnet_id                 = "${azurerm_subnet.pas_subnet.id}"
  network_security_group_id = "${var.bosh_deployed_vms_security_group_id}"
}

resource "azurerm_subnet" "services_subnet" {
  name = "${var.env_name}-services-subnet"

  //  depends_on                = ["${var.network_rg_name}"]
  resource_group_name       = "${var.network_rg_name}"
  virtual_network_name      = "${var.network_name}"
  address_prefix            = "${var.services_subnet_cidr}"
  network_security_group_id = "${var.bosh_deployed_vms_security_group_id}"
}

resource "azurerm_subnet_network_security_group_association" "services_subnet" {
  subnet_id                 = "${azurerm_subnet.services_subnet.id}"
  network_security_group_id = "${var.bosh_deployed_vms_security_group_id}"
}
