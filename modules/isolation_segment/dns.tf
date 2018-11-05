resource "azurerm_dns_a_record" "iso_dns_name" {
  name                = "*.iso-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  zone_name           = "${var.dns_zone}"
  resource_group_name = "${var.resource_group_name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.iso-web-lb-public-ip.*.ip_address[count.index]}"]
}
