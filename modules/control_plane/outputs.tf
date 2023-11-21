output "cidr" {
  value = "${var.cidr}"
}

output "postgres_fqdn" {
  value = "${element(tolist(azurerm_postgresql_server.plane.*.fqdn), 0)}"
}

output "postgres_password" {
  value = "${random_string.postgres_password.result}"
}

output "postgres_username" {
  value = "${var.postgres_username}@${element(tolist(azurerm_postgresql_server.plane.*.name), 0)}"
}

output "plane_lb_name" {
  value = "${azurerm_lb.plane.name}"
}

output "dns_name" {
  value = "${azurerm_dns_a_record.plane.name}.${azurerm_dns_a_record.plane.zone_name}"
}

output "network_name" {
  value = "${azurerm_subnet.plane.name}"
}

output "subnet_gateway" {
  value = "${cidrhost(var.cidr, 1)}"
}
