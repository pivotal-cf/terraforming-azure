resource "azurerm_public_ip" "iso-lb-public-ip" {
  name                         = "iso-lb-public-ip-${element(var.iso_seg_names, count.index)}"
  count                        = "${var.count}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

resource "azurerm_lb" "iso" {
  name                = "${var.environment}-iso-lb-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "iso-frontendip-${element(var.iso_seg_names, count.index)}"
    public_ip_address_id = "${azurerm_public_ip.iso-lb-public-ip.*.id[count.index]}"
  }
}

resource "azurerm_lb_backend_address_pool" "iso-backend-pool" {
  name                = "iso-backend-pool-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso.*.id[count.index]}"
}

resource "azurerm_lb_probe" "iso-https-probe" {
  name                = "iso-https-probe-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso.*.id[count.index]}"
  protocol            = "TCP"
  port                = 443
}

resource "azurerm_lb_rule" "iso-https-rule" {
  name                = "iso-https-rule-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso.*.id[count.index]}"

  frontend_ip_configuration_name = "iso-frontendip-${element(var.iso_seg_names, count.index)}"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso-backend-pool.*.id[count.index]}"
  probe_id                = "${azurerm_lb_probe.iso-https-probe.*.id[count.index]}"
}

resource "azurerm_lb_probe" "iso-http-probe" {
  name                = "iso-http-probe-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso.*.id[count.index]}"
  protocol            = "TCP"
  port                = 80
}

resource "azurerm_lb_rule" "iso-http-rule" {
  name                = "iso-http-rule-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso.*.id[count.index]}"

  frontend_ip_configuration_name = "iso-frontendip-${element(var.iso_seg_names, count.index)}"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso-backend-pool.*.id[count.index]}"
  probe_id                = "${azurerm_lb_probe.iso-http-probe.*.id[count.index]}"
}
