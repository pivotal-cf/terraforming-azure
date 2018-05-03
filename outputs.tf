output "iaas" {
  value = "azure"
}

output "subscription_id" {
  sensitive = true
  value     = "${var.subscription_id}"
}

output "tenant_id" {
  sensitive = true
  value     = "${var.tenant_id}"
}

output "client_id" {
  sensitive = true
  value     = "${var.client_id}"
}

output "client_secret" {
  sensitive = true
  value     = "${var.client_secret}"
}

output "ops_manager_dns" {
  value = "${azurerm_dns_a_record.ops_manager_dns.name}.${azurerm_dns_a_record.ops_manager_dns.zone_name}"
}

output "optional_ops_manager_dns" {
  value = "${element(concat(azurerm_dns_a_record.optional_ops_manager_dns.*.name, list("")), 0)}.${element(concat(azurerm_dns_a_record.optional_ops_manager_dns.*.zone_name, list("")), 0)}"
}

output "mysql_dns" {
  value = "mysql.${azurerm_dns_a_record.mysql.zone_name}"
}

output "tcp_domain" {
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

output "ssl_cert" {
  sensitive = true
  value     = "${length(var.ssl_ca_cert) > 0 ? element(concat(tls_locally_signed_cert.ssl_cert.*.cert_pem, list("")), 0) : var.ssl_cert}"
}

output "ssl_private_key" {
  sensitive = true
  value     = "${length(var.ssl_ca_cert) > 0 ? element(concat(tls_private_key.ssl_private_key.*.private_key_pem, list("")), 0) : var.ssl_private_key}"
}

output "iso_seg_ssl_cert" {
  sensitive = true
  value     = "${module.isolation_segment.ssl_cert}"
}

output "iso_seg_ssl_private_key" {
  sensitive = true
  value     = "${module.isolation_segment.ssl_private_key}"
}

output "web_lb_name" {
  value = "${azurerm_lb.web.name}"
}

output "diego_ssh_lb_name" {
  value = "${azurerm_lb.diego-ssh.name}"
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

output "management_subnets" {
  value = ["${azurerm_subnet.management_subnet.name}"]
}

output "management_subnet_cidrs" {
  value = ["${azurerm_subnet.management_subnet.address_prefix}"]
}

output "management_subnet_gateway" {
  value = "${cidrhost(azurerm_subnet.management_subnet.address_prefix, 1)}"
}

output "pas_subnet_name" {
  value = "${azurerm_subnet.pas_subnet.name}"
}

output "pas_subnets" {
  value = ["${azurerm_subnet.pas_subnet.name}"]
}

output "pas_subnet_cidrs" {
  value = ["${azurerm_subnet.pas_subnet.address_prefix}"]
}

output "pas_subnet_gateway" {
  value = "${cidrhost(azurerm_subnet.pas_subnet.address_prefix, 1)}"
}

output "services_subnet_name" {
  value = "${azurerm_subnet.services_subnet.name}"
}

output "services_subnets" {
  value = ["${azurerm_subnet.services_subnet.name}"]
}

output "services_subnet_cidrs" {
  value = ["${azurerm_subnet.services_subnet.address_prefix}"]
}

output "services_subnet_gateway" {
  value = "${cidrhost(azurerm_subnet.services_subnet.address_prefix, 1)}"
}

output "dynamic_services_subnet_name" {
  value = "${azurerm_subnet.dynamic_services_subnet.name}"
}

output "dynamic_services_subnets" {
  value = ["${azurerm_subnet.dynamic_services_subnet.name}"]
}

output "dynamic_services_subnet_cidrs" {
  value = ["${azurerm_subnet.dynamic_services_subnet.address_prefix}"]
}

output "dynamic_services_subnet_gateway" {
  value = "${cidrhost(azurerm_subnet.dynamic_services_subnet.address_prefix, 1)}"
}

output "pcf_resource_group_name" {
  value = "${azurerm_resource_group.pcf_resource_group.name}"
}

output "ops_manager_security_group_name" {
  value = "${azurerm_network_security_group.ops_manager_security_group.name}"
}

output "bosh_deployed_vms_security_group_name" {
  value = "${azurerm_network_security_group.bosh_deployed_vms_security_group.name}"
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
  sensitive = true
  value     = "${tls_private_key.ops_manager.public_key_openssh}"
}

output "ops_manager_ssh_private_key" {
  sensitive = true
  value     = "${tls_private_key.ops_manager.private_key_pem}"
}

output "ops_manager_public_ip" {
  value = "${azurerm_public_ip.ops_manager_public_ip.ip_address}"
}

output "ops_manager_ip" {
  value = "${azurerm_public_ip.ops_manager_public_ip.ip_address}"
}

output "optional_ops_manager_public_ip" {
  value = "${element(concat(azurerm_public_ip.optional_ops_manager_public_ip.*.ip_address, list("")), 0)}"
}

output "ops_manager_private_ip" {
  value = "${azurerm_network_interface.ops_manager_nic.private_ip_address}"
}

output "isolation_segment" {
  value = {
    "lb_name" = "${module.isolation_segment.lb_name}"
  }
}
