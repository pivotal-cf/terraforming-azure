locals {
  pcf_virtual_network_name = "${var.env_name}-virtual-network"
  management_subnet_name   = "${var.env_name}-management-subnet"
  pas_subnet_name          = "${var.env_name}-pas-subnet"
  services_subnet_name     = "${var.env_name}-services-subnet"
}

resource "azurerm_virtual_network" "pcf_virtual_network" {
  name                = "${var.pcf_virtual_network_name != "" ? var.pcf_virtual_network_name : local.pcf_virtual_network_name}"
  depends_on          = ["azurerm_resource_group.pcf_resource_group"]
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  address_space       = "${var.pcf_virtual_network_address_space}"
  location            = "${var.location}"
}

<<<<<<< HEAD
resource "azurerm_subnet" "management_subnet" {
  name                      = "${var.management_subnet_name != "" ? var.management_subnet_name : local.management_subnet_name}"
  depends_on                = ["azurerm_resource_group.pcf_resource_group"]
  resource_group_name       = "${azurerm_resource_group.pcf_resource_group.name}"
  virtual_network_name      = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix            = "${var.pcf_management_subnet}"
=======
resource "azurerm_subnet" "infrastructure_subnet" {
  name                 = "${var.env_name}-infrastructure-subnet"
  depends_on           = ["azurerm_resource_group.pcf_resource_group"]
  resource_group_name  = "${azurerm_resource_group.pcf_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix       = "${var.pcf_infrastructure_subnet}"
>>>>>>> 16d3bb5b449245d451e36d500fa431b27989c6e4
  network_security_group_id = "${azurerm_network_security_group.ops_manager_security_group.id}"
}

resource "azurerm_subnet" "pas_subnet" {
  name                      = "${var.pas_subnet_name != "" ? var.pas_subnet_name : local.pas_subnet_name}"
  depends_on                = ["azurerm_resource_group.pcf_resource_group"]
  resource_group_name       = "${azurerm_resource_group.pcf_resource_group.name}"
  virtual_network_name      = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix            = "${var.pcf_pas_subnet}"
  network_security_group_id = "${azurerm_network_security_group.bosh_deployed_vms_security_group.id}"
}

resource "azurerm_subnet" "services_subnet" {
  name                      = "${var.services_subnet_name != "" ? var.services_subnet_name : local.services_subnet_name}"
  depends_on                = ["azurerm_resource_group.pcf_resource_group"]
  resource_group_name       = "${azurerm_resource_group.pcf_resource_group.name}"
  virtual_network_name      = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix            = "${var.pcf_services_subnet}"
  network_security_group_id = "${azurerm_network_security_group.bosh_deployed_vms_security_group.id}"
}

resource "azurerm_subnet" "dynamic_services_subnet" {
  name                      = "${var.env_name}-dynamic-services-subnet"
  depends_on                = ["azurerm_resource_group.pcf_resource_group"]
  resource_group_name       = "${azurerm_resource_group.pcf_resource_group.name}"
  virtual_network_name      = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix            = "${var.pcf_dynamic_services_subnet}"
  network_security_group_id = "${azurerm_network_security_group.bosh_deployed_vms_security_group.id}"
}
