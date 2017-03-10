/************************
 * Isolation Segment LB *
 ************************/

resource "azurerm_public_ip" "iso-lb-public-ip" {
  name                         = "iso-lb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.pcf_resource_group.name}"
  public_ip_address_allocation = "static"

  count = "${var.create_isoseg_resources}"
}

resource "azurerm_lb" "iso" {
  name                = "${var.env_name}-iso-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  count               = "${var.create_isoseg_resources}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurerm_public_ip.iso-lb-public-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "iso-backend-pool" {
  name                = "iso-backend-pool"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.iso.id}"
  count               = "${var.create_isoseg_resources}"
}

resource "azurerm_lb_probe" "iso-https-probe" {
  name                = "iso-https-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.iso.id}"
  protocol            = "TCP"
  port                = 443
  count               = "${var.create_isoseg_resources}"
}

resource "azurerm_lb_rule" "iso-https-rule" {
  name                = "iso-https-rule"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.iso.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.iso-https-probe.id}"
  count                   = "${var.create_isoseg_resources}"
}

resource "azurerm_lb_probe" "iso-http-probe" {
  name                = "iso-http-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.iso.id}"
  protocol            = "TCP"
  port                = 80
  count               = "${var.create_isoseg_resources}"
}

resource "azurerm_lb_rule" "iso-http-rule" {
  name                = "iso-http-rule"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.iso.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.iso-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.iso-http-probe.id}"
  count                   = "${var.create_isoseg_resources}"
}
