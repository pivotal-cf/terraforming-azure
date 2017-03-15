module "isolation_segment" {
  source = "./isolation_segment"

  count = "${var.isolation_segment ? 1 : 0}"

  environment         = "${var.env_name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  dns_zone            = "${azurerm_dns_zone.env_dns_zone.name}"
}
