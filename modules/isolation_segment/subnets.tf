resource "azurerm_subnet" "iso_seg_subnet" {
  name  = "${var.environment}-iso-seg-subnet-${element(var.iso_seg_names, count.index)}"
  count = "${var.count}"

  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.network_name}"
  address_prefix       = "${element(var.iso_seg_subnets, count.index)}"
}
