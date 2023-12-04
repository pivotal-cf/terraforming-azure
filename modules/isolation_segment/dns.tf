resource "azurerm_dns_a_record" "iso" {
  name                = "*.iso"
  count               = "${var.deploy}"
  zone_name           = "${var.dns_zone}"
  resource_group_name = "${var.resource_group_name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.iso-lb-public-ip[0].ip_address}"]
}
