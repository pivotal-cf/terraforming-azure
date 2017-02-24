output "subscription_id" {
  value = "${var.subscription_id}"
}

output "tenant_id" {
  value = "${var.tenant_id}"
}

output "client_id" {
  value = "${var.client_id}"
}

output "client_secret" {
  value = "${var.client_secret}"
}

output "ops_manager_dns" {
  value = "${azurerm_dns_a_record.ops_manager_dns.name}.${azurerm_dns_a_record.ops_manager_dns.zone_name}"
}

output "optional_ops_manager_dns" {
  value = "${azurerm_dns_a_record.optional_ops_manager_dns.name}.${azurerm_dns_a_record.optional_ops_manager_dns.zone_name}"
}

output "mysql_dns" {
  value = "mysql.${azurerm_dns_a_record.mysql.zone_name}"
}

output "tcp_dns" {
  value = "tcp.${azurerm_dns_a_record.tcp.zone_name}"
}

output "sys_domain" {
  value = "sys.${azurerm_dns_a_record.sys.zone_name}"
}

output "apps_domain" {
  value = "apps.${azurerm_dns_a_record.apps.zone_name}"
}

output "env_dns_zone_name_servers" {
  value = "${azurerm_dns_zone.env_dns_zone.name_servers}"
}

output "web_lb_name" {
  value = "${azurerm_lb.web.name}"
}

output "mysql_lb_name" {
  value = "${azurerm_lb.mysql.name}"
}

output "tcp_lb_name" {
  value = "${azurerm_lb.tcp.name}"
}

output "network_name" {
  value = "${azurerm_virtual_network.pcf_virtual_network.name}"
}

output "management_subnet_name" {
  value = "${azurerm_subnet.management_subnet.name}"
}

output "management_subnet_cidrs" {
  value = ["${azurerm_subnet.management_subnet.address_prefix}"]
}

output "management_subnet_gateway" {
  value = "${cidrhost(azurerm_subnet.management_subnet.address_prefix, 1)}"
}

output "ert_subnet_name" {
  value = "${azurerm_subnet.ert_subnet.name}"
}

output "ert_subnet_cidrs" {
  value = ["${azurerm_subnet.ert_subnet.address_prefix}"]
}

output "ert_subnet_gateway" {
  value = "${cidrhost(azurerm_subnet.ert_subnet.address_prefix, 1)}"
}

output "services_subnet_name" {
  value = "${azurerm_subnet.services_subnet.name}"
}

output "services_subnet_cidrs" {
  value = ["${azurerm_subnet.services_subnet.address_prefix}"]
}

output "services_subnet_gateway" {
  value = "${cidrhost(azurerm_subnet.services_subnet.address_prefix, 1)}"
}

output "pcf_resource_group_name" {
  value = "${azurerm_resource_group.pcf_resource_group.name}"
}

output "ops_manager_security_group_name" {
  value = "${azurerm_network_security_group.ops_manager_security_group.name}"
}

output "bosh_root_storage_account" {
  value = "${azurerm_storage_account.bosh_root_storage_account.name}"
}

output "ops_manager_storage_account" {
  value = "${azurerm_storage_account.ops_manager_storage_account.name}"
}

output "wildcard_vm_storage_account" {
  value = "*${var.env_short_name}${data.template_file.base_storage_account_wildcard.rendered}*"
}

output "cf_storage_account_name" {
  value = "${azurerm_storage_account.cf_storage_account.name}"
}

output "cf_storage_account_access_key" {
  value = "${azurerm_storage_account.cf_storage_account.primary_access_key}"
}

output "cf_droplets_storage_container" {
  value = "${azurerm_storage_container.cf_droplets_storage_container.name}"
}

output "cf_packages_storage_container" {
  value = "${azurerm_storage_container.cf_packages_storage_container.name}"
}

output "cf_resources_storage_container" {
  value = "${azurerm_storage_container.cf_resources_storage_container.name}"
}

output "cf_buildpacks_storage_container" {
  value = "${azurerm_storage_container.cf_buildpacks_storage_container.name}"
}

output "ops_manager_ssh_public_key" {
  value = "${tls_private_key.ops_manager.public_key_openssh}"
}

output "ops_manager_ssh_private_key" {
  value = "${tls_private_key.ops_manager.private_key_pem}"
}

output "ops_manager_public_ip" {
  value = "${azurerm_public_ip.ops_manager_public_ip.ip_address}"
}
