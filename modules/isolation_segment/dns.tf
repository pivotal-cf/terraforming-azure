resource "azurerm_dns_a_record" "iso_dns_name" {
  name                = "*.iso-${element(var.iso_seg_names, count.index)}"
  count               = "${length(var.iso_seg_names)}"
  zone_name           = "${var.dns_zone}"
  resource_group_name = "${var.resource_group_name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.iso_lb_public_ip.*.ip_address[count.index]}"]
}
