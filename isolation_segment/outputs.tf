output "lb_name" {
  value = "${element(concat(azurerm_lb.iso.*.name, list("")), 0)}"
}
