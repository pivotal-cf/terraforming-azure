// Security Group for PKS API Nodes

resource "azurerm_application_security_group" "pks-master" {
  name                = "${var.env_id}-pks-master-app-sec-group"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_application_security_group" "pks-api" {
  name                = "${var.env_id}-pks-api-app-sec-group"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

// Allow access from the internet to the masters
resource "azurerm_network_security_group" "pks-master" {
  name                = "${var.env_id}-pks-master-sg"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                                       = "master"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "8443"
    source_address_prefix                      = "*"
    destination_application_security_group_ids = ["${azurerm_application_security_group.pks-master.id}"]
  }
}

// Allow access from the internet to the PKS API VM
resource "azurerm_network_security_group" "pks-api" {
  name                = "${var.env_id}-pks-api-sg"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                                       = "api"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_ranges                    = ["9021", "8443"]
    source_address_prefix                      = "*"
    destination_application_security_group_ids = ["${azurerm_application_security_group.pks-api.id}"]
  }
}

// Allow access from the internal VMs to the internal VMs via TCP and UDP
resource "azurerm_network_security_group" "pks-internal" {
  name                = "${var.env_id}-pks-internal-sg"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "internal"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["${local.pks_cidr}", "${local.pks_services_cidr}"]
    destination_address_prefix = "*"
  }
}
