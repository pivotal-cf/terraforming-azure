resource "azurerm_public_ip" "iso-diego-ssh-lb-public-ip" {
  name                         = "iso-diego-ssh-lb-public-ip-${element(var.iso_seg_names, count.index)}"
  count                        = "${var.count}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

resource "azurerm_lb" "iso-diego-ssh" {
  name                = "${var.environment}-iso-diego-ssh-lb-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "iso-diego-ssh-frontendip-${element(var.iso_seg_names, count.index)}"
    public_ip_address_id = "${azurerm_public_ip.iso-diego-ssh-lb-public-ip.*.id[count.index]}"
  }
}

resource "azurerm_lb_backend_address_pool" "iso-diego-ssh-backend-pool" {
  name                = "iso-diego-ssh-backend-pool-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-diego-ssh.*.id[count.index]}"
}

resource "azurerm_lb_probe" "iso-diego-ssh-probe" {
  name                = "iso-diego-ssh-probe-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-diego-ssh.*.id[count.index]}"
  protocol            = "TCP"
  port                = 2222
}

resource "azurerm_lb_rule" "iso-diego-ssh-rule" {
  name                = "iso-diego-ssh-rule-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-diego-ssh.*.id[count.index]}"

  frontend_ip_configuration_name = "iso-diego-ssh-frontendip-${element(var.iso_seg_names, count.index)}"
  protocol                       = "TCP"
  frontend_port                  = 2222
  backend_port                   = 2222

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso-diego-ssh-backend-pool.*.id[count.index]}"
  probe_id                = "${azurerm_lb_probe.iso-diego-ssh-probe.*.id[count.index]}"
}

resource "azurerm_lb_rule" "iso-diego-ssh-ntp" {
  name                = "iso-diego-ssh-ntp-rule-${element(var.iso_seg_names, count.index)}"
  count               = "${var.count}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.iso-diego-ssh.*.id[count.index]}"

  frontend_ip_configuration_name = "iso-diego-ssh-frontendip-${element(var.iso_seg_names, count.index)}"
  protocol                       = "UDP"
  frontend_port                  = "123"
  backend_port                   = "123"

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso-diego-ssh-backend-pool.*.id[count.index]}"
}
