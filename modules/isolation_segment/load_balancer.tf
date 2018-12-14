resource "azurerm_public_ip" "iso_lb_public_ip" {
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
    public_ip_address_id = "${azurerm_public_ip.iso_lb_public_ip.*.id[count.index]}"
  }
}

resource "azurerm_lb_backend_address_pool" "iso_backend_pool" {
  name                = "iso-backend-pool-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso.*.id[count.index]}"
}

resource "azurerm_lb_probe" "iso_https_probe" {
  name                = "iso-https-probe-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso.*.id[count.index]}"
  protocol            = "TCP"
  port                = 443
}

resource "azurerm_lb_rule" "iso_https_rule" {
  name                = "iso-https-rule-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso.*.id[count.index]}"

  frontend_ip_configuration_name = "iso-frontendip-${element(var.iso_seg_names, count.index)}"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso_backend_pool.*.id[count.index]}"
  probe_id                = "${azurerm_lb_probe.iso_https_probe.*.id[count.index]}"
}

resource "azurerm_lb_probe" "iso_http_probe" {
  name                = "iso-http-probe-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso.*.id[count.index]}"
  protocol            = "TCP"
  port                = 80
}

resource "azurerm_lb_rule" "iso_http_rule" {
  name                = "iso-http-rule-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso.*.id[count.index]}"

  frontend_ip_configuration_name = "iso-frontendip-${element(var.iso_seg_names, count.index)}"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso_backend_pool.*.id[count.index]}"
  probe_id                = "${azurerm_lb_probe.iso_http_probe.*.id[count.index]}"
}
