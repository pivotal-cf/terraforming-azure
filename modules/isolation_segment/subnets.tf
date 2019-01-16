resource "azurerm_subnet" "iso_seg_subnet" {
  name  = "${var.env_name}-iso-seg-subnet-${element(var.iso_seg_names, count.index)}"
  count = "${length(var.iso_seg_names)}"

  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.network_name}"
  address_prefix       = "${element(var.iso_seg_subnets, count.index)}"
}
