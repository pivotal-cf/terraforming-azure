variable "env_name" {
  default = ""
}

variable "pcf_vnet_rg" {
  default = ""
}

variable "create_vnet" {
  default = true
}

variable "vnet_name" {
  default = ""
}

variable "location" {
  default = ""
}

variable "dns_subdomain" {
  default = ""
}

variable "dns_suffix" {
}

variable "pcf_virtual_network_address_space" {
  type    = "list"
  default = []
}

variable "pcf_infrastructure_subnet" {
  default = ""
}

resource "azurerm_resource_group" "pcf_resource_group" {
  name     = "${var.env_name}"
  location = "${var.location}"
}

resource "azurerm_resource_group" "pcf_network_rg" {
  name = "${var.pcf_vnet_rg != "" ? var.pcf_vnet_rg : var.env_name}"
  location = "${var.location}"
}

# ============== Security Groups ===============

resource "azurerm_network_security_group" "ops_manager_security_group" {
  name                = "${var.env_name}-ops-manager-security-group"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_network_rg.name}"

  security_rule {
    name                       = "ssh"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    priority                   = 204
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 205
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = 443
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "bosh_deployed_vms_security_group" {
  name                = "${var.env_name}-bosh-deployed-vms-security-group"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_network_rg.name}"

  security_rule {
    name                       = "internal-anything"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ssh"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "bosh-agent"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 6868
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "bosh-director"
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 25555
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "dns"
    priority                   = 203
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = 53
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    priority                   = 204
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 205
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = 443
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "loggregator"
    priority                   = 206
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = 4443
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # TODO: remove this rule once we have an internal mysql LB
  security_rule {
    name                       = "mysql"
    priority                   = 207
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3306
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # TODO: remove this rule once we have an internal mysql LB
  security_rule {
    name                       = "mysql-healthcheck"
    priority                   = 208
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 1936
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "diego-ssh"
    priority                   = 209
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 2222
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "tcp"
    priority                   = 210
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1024-1173"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

# ============= Networking

resource "azurerm_virtual_network" "pcf_virtual_network" {
  count               = "${var.create_vnet ? "1" : "0"}"
  name                = "${var.vnet_name != "" ? "${var.vnet_name}" : "${var.env_name}-virtual-network"}"
  depends_on          = ["azurerm_resource_group.pcf_network_rg"]
  resource_group_name = "${azurerm_resource_group.pcf_network_rg.name}"
  address_space       = "${var.pcf_virtual_network_address_space}"
  location            = "${var.location}"
}

data "azurerm_virtual_network" "pcf_virtual_network" {
  name                = "${var.create_vnet ? "${var.vnet_name != "" ? "${var.vnet_name}" : "${var.env_name}-virtual-network"}" : "${var.vnet_name}"}"
  depends_on          = ["azurerm_virtual_network.pcf_virtual_network"]
  resource_group_name = "${azurerm_resource_group.pcf_network_rg.name}"
}

resource "azurerm_subnet" "infrastructure_subnet" {
  name                      = "${var.env_name}-infrastructure-subnet"
  depends_on                = ["azurerm_resource_group.pcf_network_rg"]
  resource_group_name       = "${azurerm_resource_group.pcf_network_rg.name}"
  virtual_network_name      = "${data.azurerm_virtual_network.pcf_virtual_network.name}"
  address_prefix            = "${var.pcf_infrastructure_subnet}"
  network_security_group_id = "${azurerm_network_security_group.ops_manager_security_group.id}"
}

resource "azurerm_subnet_network_security_group_association" "ops_manager_security_group" {
  subnet_id                 = "${azurerm_subnet.infrastructure_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.ops_manager_security_group.id}"
}

# ============= DNS

locals {
  dns_subdomain = "${var.env_name}"
}

resource "azurerm_dns_zone" "env_dns_zone" {
  name                = "${var.dns_subdomain != "" ? var.dns_subdomain : local.dns_subdomain}.${var.dns_suffix}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
}

output "dns_zone_name" {
  value = "${azurerm_dns_zone.env_dns_zone.name}"
}

output "dns_zone_name_servers" {
  value = "${azurerm_dns_zone.env_dns_zone.name_servers}"
}

output "resource_group_name" {
  value = "${azurerm_resource_group.pcf_resource_group.name}"
}

output "network_rg_name" {
  value = "${azurerm_resource_group.pcf_network_rg.name}"
}

output "network_name" {
  value = "${data.azurerm_virtual_network.pcf_virtual_network.name}"
}

output "infrastructure_subnet_id" {
  value = "${azurerm_subnet.infrastructure_subnet.id}"
}

output "infrastructure_subnet_name" {
  value = "${azurerm_subnet.infrastructure_subnet.name}"
}

output "infrastructure_subnet_cidr" {
  value = "${azurerm_subnet.infrastructure_subnet.address_prefix}"
}

output "infrastructure_subnet_gateway" {
  value = "${cidrhost(azurerm_subnet.infrastructure_subnet.address_prefix, 1)}"
}

output "security_group_id" {
  value = "${azurerm_network_security_group.ops_manager_security_group.id}"
}

output "security_group_name" {
  value = "${azurerm_network_security_group.ops_manager_security_group.name}"
}

output "bosh_deployed_vms_security_group_id" {
  value = "${azurerm_network_security_group.bosh_deployed_vms_security_group.id}"
}

output "bosh_deployed_vms_security_group_name" {
  value = "${azurerm_network_security_group.bosh_deployed_vms_security_group.name}"
}

# Deprecated

output "infrastructure_subnet_cidrs" {
  value = ["${azurerm_subnet.infrastructure_subnet.address_prefix}"]
}
