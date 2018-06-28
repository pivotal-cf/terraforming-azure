locals {
  dns_subdomain = "${var.env_name}"
}

resource "azurerm_dns_zone" "env_dns_zone" {
  name                = "${var.dns_subdomain != "" ? var.dns_subdomain : local.dns_subdomain}.${var.dns_suffix}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
}

resource "azurerm_dns_a_record" "ops_manager_dns" {
  name                = "pcf"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.ops_manager_public_ip.ip_address}"]
}

resource "azurerm_dns_a_record" "optional_ops_manager_dns" {
  name                = "pcf-optional"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.optional_ops_manager_public_ip.ip_address}"]
  count               = "${min(length(split("", var.optional_ops_manager_image_uri)),1)}"
}

resource "azurerm_dns_a_record" "apps" {
  name                = "*.apps"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.web-lb-public-ip.ip_address}"]
}

resource "azurerm_dns_a_record" "sys" {
  name                = "*.sys"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.web-lb-public-ip.ip_address}"]
}

resource "azurerm_dns_a_record" "ssh" {
  name                = "ssh.sys"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.diego-ssh-lb-public-ip.ip_address}"]
}

resource "azurerm_dns_a_record" "mysql" {
  name                = "mysql"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  ttl                 = "60"
  records             = ["${azurerm_lb.mysql.frontend_ip_configuration.0.private_ip_address}"]
}

resource "azurerm_dns_a_record" "tcp" {
  name                = "tcp"
  zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.tcp-lb-public-ip.ip_address}"]
}
