resource "azurerm_public_ip" "tcp-lb-public-ip" {
  name                         = "tcp-lb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.pcf_resource_group.name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

resource "azurerm_lb" "tcp" {
  name                = "${var.env_name}-tcp-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurerm_public_ip.tcp-lb-public-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "tcp-backend-pool" {
  name                = "tcp-backend-pool"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.tcp.id}"
}

resource "azurerm_lb_probe" "tcp-probe" {
  name                = "tcp-probe"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.tcp.id}"
  protocol            = "TCP"
  port                = 80
}

resource "azurerm_lb_rule" "tcp-rule" {
  count               = 150
  name                = "tcp-rule-${count.index + 1024}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.tcp.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = "${count.index + 1024}"
  backend_port                   = "${count.index + 1024}"

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.tcp-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.tcp-probe.id}"
}

resource "azurerm_lb_rule" "tcp-ntp-rule" {
  name                = "tcp-ntp-rule"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.tcp.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "UDP"
  frontend_port                  = 123
  backend_port                   = 123

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.tcp-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.tcp-probe.id}"
}
