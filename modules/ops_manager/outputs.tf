# ==================== Outputs

output "dns_name" {
  value = "${azurerm_dns_a_record.ops_manager_dns.name}.${azurerm_dns_a_record.ops_manager_dns.zone_name}"
}

output "optional_dns_name" {
  value = "${element(concat(azurerm_dns_a_record.optional_ops_manager_dns.*.name, list("")), 0)}.${element(concat(azurerm_dns_a_record.optional_ops_manager_dns.*.zone_name, list("")), 0)}"
}

output "ops_manager_private_ip" {
  value = "${var.ops_manager_private_ip}"
}

output "ops_manager_public_ip" {
  value = "${azurerm_public_ip.ops_manager_public_ip.ip_address}"
}

output "optional_ops_manager_public_ip" {
  value = "${element(concat(azurerm_public_ip.optional_ops_manager_public_ip.*.ip_address, list("")), 0)}"
}

output "ops_manager_ssh_public_key" {
  sensitive = true
  value     = "${tls_private_key.ops_manager.public_key_openssh}"
}

output "ops_manager_ssh_private_key" {
  sensitive = true
  value     = "${tls_private_key.ops_manager.private_key_pem}"
}

output "ops_manager_storage_account" {
  value = "${azurerm_storage_account.ops_manager_storage_account.name}"
}

output "ops_manager_storage_account_access_key" {
  sensitive = true
  value     = "${azurerm_storage_account.ops_manager_storage_account.primary_access_key}"
}
