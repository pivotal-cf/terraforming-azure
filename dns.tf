resource "azurerm_dns_zone" "env_dns_zone" {
  name                = "${var.env_name}.${var.dns_suffix}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
}

resource "azurerm_dns_a_record" "ops_manager_dns" {
  name                = "pcf"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.ops_manager_public_ip.ip_address}"]
}

resource "azurerm_dns_cname_record" "apps" {
  name                = "*.apps"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  ttl                 = "60"
  record              = "${var.env_name}-web-lb-public-ip.${var.location}.cloudapp.azure.com"
}

resource "azurerm_dns_cname_record" "sys" {
  name                = "*.sys"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  ttl                 = "60"
  record              = "${var.env_name}-web-lb-public-ip.${var.location}.cloudapp.azure.com"
}

resource "azurerm_dns_cname_record" "mysql" {
  name                = "mysql"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  ttl                 = "60"
  record              = "${var.env_name}-mysql-lb-public-ip.${var.location}.cloudapp.azure.com"
}
