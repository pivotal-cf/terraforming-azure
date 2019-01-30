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

output "ssl_cert" {
  sensitive = true
  value     = "${length(module.certs.ssl_cert) > 0 ? module.certs.ssl_cert : var.ssl_cert}"
}

output "ssl_private_key" {
  sensitive = true
  value     = "${length(module.certs.ssl_private_key) > 0 ? module.certs.ssl_private_key : var.ssl_private_key}"
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

output "pks-master-app-sec-group" {
  value = "${module.pks.pks-master-app-sec-group}"
}

# Subnets

output "pks_subnet_name" {
  value = "${module.pks.pks_subnet_name}"
}

output "pks_subnet_cidr" {
  value = "${module.pks.pks_subnet_cidr}"
}

output "pks_subnet_gateway" {
  value = "${module.pks.pks_subnet_gateway}"
}

output "services_subnet_name" {
  value = "${module.pks.services_subnet_name}"
}

output "services_subnet_cidr" {
  value = "${module.pks.services_subnet_cidr}"
}

output "services_subnet_gateway" {
  value = "${module.pks.services_subnet_gateway}"
}

# Deprecated properties

output "management_subnet_name" {
  value = "${module.infra.infrastructure_subnet_name}"
}

output "management_subnets" {
  value = ["${module.infra.infrastructure_subnet_name}"]
}

output "management_subnet_cidrs" {
  value = ["${module.infra.infrastructure_subnet_cidrs}"]
}

output "management_subnet_gateway" {
  value = "${module.infra.infrastructure_subnet_gateway}"
}

output "infrastructure_subnets" {
  value = ["${module.infra.infrastructure_subnet_name}"]
}

output "infrastructure_subnet_cidrs" {
  value = "${module.infra.infrastructure_subnet_cidrs}"
}

output "pks_subnet_cidrs" {
  value = "${module.pks.pks_subnet_cidrs}"
}

output "pks_subnets" {
  value = ["${module.pks.pks_subnet_name}"]
}

output "services_subnets" {
  value = ["${module.pks.services_subnet_name}"]
}

output "services_subnet_cidrs" {
  value = "${module.pks.services_subnet_cidrs}"
}
