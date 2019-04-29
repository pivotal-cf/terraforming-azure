resource "azurerm_public_ip" "istio-lb-public-ip" {
  name                    = "istio-lb-public-ip"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  allocation_method       = "Static"
  sku                     = "Standard"
  idle_timeout_in_minutes = 30
}

resource "azurerm_lb" "istio" {
  name                = "${var.env_name}-istio-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurerm_public_ip.istio-lb-public-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "istio-backend-pool" {
  name                = "istio-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.istio.id}"
}


resource "azurerm_lb_rule" "istio-https-rule" {
  name                = "istio-https-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.istio.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.istio-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.istio-http-probe.id}"
}

resource "azurerm_lb_probe" "istio-http-probe" {
  name                = "istio-http-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.istio.id}"
  protocol            = "http"
  port                = 8002
  request_path            = "/healthcheck"
}

resource "azurerm_lb_rule" "istio-http-rule" {
  name                = "istio-http-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.istio.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.istio-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.istio-http-probe.id}"
}

resource "azurerm_lb_rule" "istio-health-rule" {
  name                = "istio-health-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.istio.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = "8002"
  backend_port                   = "8002"

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.istio-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.istio-http-probe.id}"
}
