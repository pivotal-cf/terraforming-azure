resource "azurerm_public_ip" "web-lb-public-ip" {
  name                         = "web-lb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.pcf_resource_group.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_lb" "web" {
  name                = "${var.env_name}-web-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurerm_public_ip.web-lb-public-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "web-backend-pool" {
  depends_on          = ["azurerm_lb.web"]
  name                = "web-backend-pool"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"
}

resource "azurerm_lb_probe" "web-https-probe" {
  depends_on          = ["azurerm_lb.web"]
  name                = "web-https-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"
  protocol            = "TCP"
  port                = 443
}

resource "azurerm_lb_rule" "web-https-rule" {
  depends_on          = ["azurerm_lb.web"]
  name                = "web-https-rule"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.web.id}/backendAddressPools/${azurerm_lb_backend_address_pool.web-backend-pool.name}"
  probe_id                = "${azurerm_lb.web.id}/probes/${azurerm_lb_probe.web-https-probe.name}"
}

resource "azurerm_lb_probe" "web-http-probe" {
  depends_on          = ["azurerm_lb.web"]
  name                = "web-http-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"
  protocol            = "TCP"
  port                = 80
}

resource "azurerm_lb_rule" "web-http-rule" {
  depends_on          = ["azurerm_lb.web"]
  name                = "web-http-rule"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.web.id}/backendAddressPools/${azurerm_lb_backend_address_pool.web-backend-pool.name}"
  probe_id                = "${azurerm_lb.web.id}/probes/${azurerm_lb_probe.web-http-probe.name}"
}

resource "azurerm_lb_probe" "web-ssh-probe" {
  depends_on          = ["azurerm_lb.web"]
  name                = "web-ssh-probe"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"
  protocol            = "TCP"
  port                = 2222
}

resource "azurerm_lb_rule" "web-ssh-rule" {
  depends_on          = ["azurerm_lb.web"]
  name                = "web-ssh-rule"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 2222
  backend_port                   = 2222

  # Workaround until the backend_address_pool and probe resources output their own ids
  backend_address_pool_id = "${azurerm_lb.web.id}/backendAddressPools/${azurerm_lb_backend_address_pool.web-backend-pool.name}"
  probe_id                = "${azurerm_lb.web.id}/probes/${azurerm_lb_probe.web-ssh-probe.name}"
}
