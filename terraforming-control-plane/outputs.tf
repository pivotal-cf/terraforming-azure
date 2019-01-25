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
  value = "${module.ops_manager.dns_name}"
}

output "optional_ops_manager_dns" {
  value = "${module.ops_manager.optional_dns_name}"
}

output "env_dns_zone_name_servers" {
  value = "${module.infra.dns_zone_name_servers}"
}

output "network_name" {
  value = "${module.infra.network_name}"
}

output "infrastructure_subnet_name" {
  value = "${module.infra.infrastructure_subnet_name}"
}

output "infrastructure_subnet_cidr" {
  value = "${module.infra.infrastructure_subnet_cidr}"
}

output "infrastructure_subnet_gateway" {
  value = "${module.infra.infrastructure_subnet_gateway}"
}

output "pcf_resource_group_name" {
  value = "${module.infra.resource_group_name}"
}

output "ops_manager_security_group_name" {
  value = "${module.infra.security_group_name}"
}

output "bosh_deployed_vms_security_group_name" {
  value = "${module.infra.bosh_deployed_vms_security_group_name}"
}

output "bosh_root_storage_account" {
  value = "${module.infra.bosh_root_storage_account}"
}

output "ops_manager_storage_account" {
  value = "${module.ops_manager.ops_manager_storage_account}"
}

output "wildcard_vm_storage_account" {
  value = "${module.infra.wildcard_vm_storage_account}"
}

output "ops_manager_ssh_public_key" {
  sensitive = true
  value     = "${module.ops_manager.ops_manager_ssh_public_key}"
}

output "ops_manager_ssh_private_key" {
  sensitive = true
  value     = "${module.ops_manager.ops_manager_ssh_private_key}"
}

output "ops_manager_public_ip" {
  value = "${module.ops_manager.ops_manager_public_ip}"
}

output "ops_manager_ip" {
  value = "${module.ops_manager.ops_manager_public_ip}"
}

output "optional_ops_manager_public_ip" {
  value = "${module.ops_manager.optional_ops_manager_public_ip}"
}

output "ops_manager_private_ip" {
  value = "${module.ops_manager.ops_manager_private_ip}"
}

# Control Plane ==========================================================================

output "control_plane_subnet_cidr" {
  value = "${module.control_plane.cidr}"
}

output "control_plane_subnet_name" {
  value = "${module.control_plane.network_name}"
}

output "control_plane_subnet_gateway" {
  value = "${module.control_plane.subnet_gateway}"
}

output "control_plane_db_password" {
  sensitive = true
  value     = "${var.external_db > 0 ? module.control_plane.postgres_password : "" }"
}

output "control_plane_fqdn" {
  value = "${module.control_plane.postgres_fqdn}"
}

output "control_plane_lb_name" {
  value = "${module.control_plane.plane_lb_name}"
}

output "control_plane_db_username" {
  value = "${var.external_db > 0 ? module.control_plane.postgres_username : ""}"
}

output "control_plane_domain" {
  value = "${module.control_plane.dns_name}"
}
