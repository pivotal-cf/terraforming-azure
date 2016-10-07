resource "azurerm_resource_group" "pcf_resource_group" {
  name     = "${var.env_name}-pcf-resource-group"
  location = "${var.location}"
}
