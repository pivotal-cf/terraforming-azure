locals {
  name_prefix = "${var.env_name}-plane"
  web_ports   = [80, 443, 8443, 8844, 2222]
}

# DNS

resource "azurerm_dns_a_record" "plane" {
  resource_group_name = "${var.resource_group_name}"
  name                = "plane"
  zone_name           = "${var.dns_zone_name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.plane.ip_address}"]
}

# Firewall

resource "azurerm_network_security_group" "plane" {
  name                = "${local.name_prefix}-security-group"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_network_security_rule" "plane" {
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.plane.name}"

  name                       = "${local.name_prefix}-security-group-rule"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_ranges    = "${local.web_ports}"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

# Network

resource "azurerm_subnet" "plane" {
  name                 = "${local.name_prefix}-subnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.network_name}"
  address_prefix       = "${var.cidr}"
}
