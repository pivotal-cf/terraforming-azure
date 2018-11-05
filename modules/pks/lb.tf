resource "azurerm_public_ip" "pks-lb-ip" {
  name                         = "${var.env_id}-pks-lb-ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

resource "azurerm_lb" "pks-lb" {
  name                = "${var.env_id}-pks-lb"
  location            = "${var.location}"
  sku                 = "Standard"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name                 = "${azurerm_public_ip.pks-lb-ip.name}"
    public_ip_address_id = "${azurerm_public_ip.pks-lb-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "pks-lb-backend-pool" {
  name                = "${var.env_id}-pks-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pks-lb.id}"
}

resource "azurerm_lb_probe" "api-health-probe" {
  name                = "${var.env_id}-api-health-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pks-lb.id}"
  protocol            = "Tcp"
  interval_in_seconds = 5
  number_of_probes    = 2
  port                = 8443
}

resource "azurerm_lb_rule" "pks-lb-api-rule" {
  name                           = "${var.env_id}-api-rule"
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.pks-lb.id}"
  protocol                       = "Tcp"
  frontend_port                  = 8443
  backend_port                   = 8443
  frontend_ip_configuration_name = "${azurerm_public_ip.pks-lb-ip.name}"
  probe_id                       = "${azurerm_lb_probe.api-health-probe.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.pks-lb-backend-pool.id}"
}
