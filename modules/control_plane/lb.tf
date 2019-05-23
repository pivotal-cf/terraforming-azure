resource "azurerm_public_ip" "plane" {
  resource_group_name = "${var.resource_group_name}"
  name                = "${local.name_prefix}-ip"
  location            = "${var.location}"
  allocation_method   = "Static"
}

resource "azurerm_lb" "plane" {
  resource_group_name = "${var.resource_group_name}"
  name                = "${var.env_name}-lb"
  location            = "${var.location}"

  frontend_ip_configuration {
    name                 = "${local.name_prefix}-ip"
    public_ip_address_id = "${azurerm_public_ip.plane.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "plane" {
  resource_group_name = "${var.resource_group_name}"
  name                = "${local.name_prefix}-pool"
  loadbalancer_id     = "${azurerm_lb.plane.id}"
}

resource "azurerm_lb_probe" "plane" {
  resource_group_name = "${var.resource_group_name}"
  count               = "${length(local.web_ports)}"
  name                = "${local.name_prefix}-${element(local.web_ports, count.index)}-probe"

  port     = "${element(local.web_ports, count.index)}"
  protocol = "Tcp"

  loadbalancer_id     = "${azurerm_lb.plane.id}"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "plane" {
  resource_group_name = "${var.resource_group_name}"
  count               = "${length(local.web_ports)}"
  name                = "${local.name_prefix}-${element(local.web_ports, count.index)}"

  protocol                       = "Tcp"
  loadbalancer_id                = "${azurerm_lb.plane.id}"
  frontend_port                  = "${element(local.web_ports, count.index)}"
  backend_port                   = "${element(local.web_ports, count.index)}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.plane.id}"
  frontend_ip_configuration_name = "${azurerm_public_ip.plane.name}"
  probe_id                       = "${element(azurerm_lb_probe.plane.*.id, count.index)}"
}
