resource "azurerm_public_ip" "iso-tcp-lb-public-ip" {
  name                         = "iso-tcp-lb-public-ip-${element(var.iso_seg_names, count.index)}"
  count                        = "${var.count}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

resource "azurerm_lb" "iso-tcp" {
  name                = "${var.environment}-iso-tcp-lb-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "iso-tcp-frontendip-${element(var.iso_seg_names, count.index)}"
    public_ip_address_id = "${azurerm_public_ip.iso-tcp-lb-public-ip.*.id[count.index]}"
  }
}

resource "azurerm_lb_backend_address_pool" "iso-tcp-backend-pool" {
  name                = "iso-tcp-backend-pool-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-tcp.*.id[count.index]}"
}

resource "azurerm_lb_probe" "iso-tcp-probe" {
  name                = "iso-tcp-probe-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-tcp.*.id[count.index]}"
  protocol            = "TCP"
  port                = 80
}

resource "azurerm_lb_rule" "iso-tcp-rule" {
  count               = "${5 * var.count}"
  name                = "iso-tcp-rule-${count.index % 5 + 1024}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-tcp.*.id[count.index % var.count]}"

  frontend_ip_configuration_name = "iso-tcp-frontendip-${element(var.iso_seg_names, count.index)}"
  protocol                       = "TCP"
  frontend_port                  = "${count.index % 5 + 1024}"
  backend_port                   = "${count.index % 5 + 1024}"

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso-tcp-backend-pool.*.id[count.index % var.count]}"
  probe_id                = "${azurerm_lb_probe.iso-tcp-probe.*.id[count.index % var.count]}"
}

resource "azurerm_lb_rule" "iso-tcp-ntp" {
  name                = "iso-tcp-ntp-rule-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-tcp.*.id[count.index]}"

  frontend_ip_configuration_name = "iso-tcp-frontendip-${element(var.iso_seg_names, count.index)}"
  protocol                       = "UDP"
  frontend_port                  = "123"
  backend_port                   = "123"

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso-tcp-backend-pool.*.id[count.index]}"
}
