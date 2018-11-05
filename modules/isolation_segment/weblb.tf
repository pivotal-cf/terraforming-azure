resource "azurerm_public_ip" "iso-web-lb-public-ip" {
  name                         = "iso-web-lb-public-ip-${element(var.iso_seg_names, count.index)}"
  count                        = "${var.count}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

resource "azurerm_lb" "iso-web" {
  name                = "${var.environment}-iso-web-lb-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "iso-web-frontendip-${element(var.iso_seg_names, count.index)}"
    public_ip_address_id = "${azurerm_public_ip.iso-web-lb-public-ip.*.id[count.index]}"
  }
}

resource "azurerm_lb_backend_address_pool" "iso-web-backend-pool" {
  name                = "iso-web-backend-pool-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-web.*.id[count.index]}"
}

resource "azurerm_lb_probe" "iso-web-https-probe" {
  name                = "iso-web-https-probe-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-web.*.id[count.index]}"
  protocol            = "TCP"
  port                = 443
}

resource "azurerm_lb_rule" "iso-web-https-rule" {
  name                = "iso-web-https-rule-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-web.*.id[count.index]}"

  frontend_ip_configuration_name = "iso-web-frontendip-${element(var.iso_seg_names, count.index)}"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso-web-backend-pool.*.id[count.index]}"
  probe_id                = "${azurerm_lb_probe.iso-web-https-probe.*.id[count.index]}"
}

resource "azurerm_lb_probe" "iso-web-http-probe" {
  name                = "iso-web-http-probe-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-web.*.id[count.index]}"
  protocol            = "TCP"
  port                = 80
}

resource "azurerm_lb_rule" "iso-web-http-rule" {
  name                = "iso-web-http-rule-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-web.*.id[count.index]}"

  frontend_ip_configuration_name = "iso-web-frontendip-${element(var.iso_seg_names, count.index)}"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso-web-backend-pool.*.id[count.index]}"
  probe_id                = "${azurerm_lb_probe.iso-web-http-probe.*.id[count.index]}"
}

resource "azurerm_lb_rule" "iso-web-ntp" {
  name                = "iso-web-ntp-rule-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-web.*.id[count.index]}"

  frontend_ip_configuration_name = "iso-web-frontendip-${element(var.iso_seg_names, count.index)}"
  protocol                       = "UDP"
  frontend_port                  = "123"
  backend_port                   = "123"

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso-web-backend-pool.*.id[count.index]}"
}
