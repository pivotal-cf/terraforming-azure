resource "azurerm_virtual_network" "pcf_virtual_network" {
  name                = "${var.env_name}-virtual-network"
  depends_on          = ["azurerm_resource_group.pcf_resource_group"]
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
}

resource "azurerm_subnet" "management_subnet" {
  name                 = "${var.env_name}-management-subnet"
  depends_on           = ["azurerm_resource_group.pcf_resource_group"]
  resource_group_name  = "${azurerm_resource_group.pcf_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix       = "10.0.8.0/26"
}

resource "azurerm_subnet" "pas_subnet" {
  name                 = "${var.env_name}-pas-subnet"
  depends_on           = ["azurerm_resource_group.pcf_resource_group"]
  resource_group_name  = "${azurerm_resource_group.pcf_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix       = "10.0.0.0/22"
}

resource "azurerm_subnet" "services_subnet" {
  name                 = "${var.env_name}-services-subnet"
  depends_on           = ["azurerm_resource_group.pcf_resource_group"]
  resource_group_name  = "${azurerm_resource_group.pcf_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix       = "10.0.4.0/22"
}

resource "azurerm_subnet" "dynamic_services_subnet" {
  name                 = "${var.env_name}-dynamic-services-subnet"
  depends_on           = ["azurerm_resource_group.pcf_resource_group"]
  resource_group_name  = "${azurerm_resource_group.pcf_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix       = "10.0.12.0/22"
}
