# ==================== Outputs

output "dns_name" {
  value = "${azurerm_dns_a_record.ops_manager_dns.name}.${azurerm_dns_a_record.ops_manager_dns.zone_name}"
}

output "optional_dns_name" {
  value = length(azurerm_dns_a_record.optional_ops_manager_dns) > 0 ? "${element(tolist(azurerm_dns_a_record.optional_ops_manager_dns[0].name), 0)}.${element(tolist(azurerm_dns_a_record.optional_ops_manager_dns.*.zone_name), 0)}" : ""
}

output "ops_manager_private_ip" {
  value = "${var.ops_manager_private_ip}"
}

output "ops_manager_public_ip" {
  value = "${azurerm_public_ip.ops_manager_public_ip.ip_address}"
}

output "optional_ops_manager_public_ip" {
  value = length(azurerm_dns_a_record.optional_ops_manager_dns) > 0 ? "${element(tolist(azurerm_public_ip.optional_ops_manager_public_ip[0].ip_address), 0)}" : ""
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
