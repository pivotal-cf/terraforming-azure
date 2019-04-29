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

output "mysql_dns" {
  value = "${module.pas.mysql_dns}"
}

output "tcp_domain" {
  value = "${module.pas.tcp_domain}"
}

output "sys_domain" {
  value = "${module.pas.sys_domain}"
}

output "apps_domain" {
  value = "${module.pas.apps_domain}"
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

output "iso_seg_ssl_cert" {
  sensitive = true
  value     = "${module.isolation_segment.ssl_cert}"
}

output "iso_seg_ssl_private_key" {
  sensitive = true
  value     = "${module.isolation_segment.ssl_private_key}"
}

output "web_lb_name" {
  value = "${module.pas.web_lb_name}"
}

output "diego_ssh_lb_name" {
  value = "${module.pas.diego_ssh_lb_name}"
}

output "mysql_lb_name" {
  value = "${module.pas.mysql_lb_name}"
}

output "istio_lb_name" {
  value = "${module.pas.istio_lb_name}"
}
output "tcp_lb_name" {
  value = "${module.pas.tcp_lb_name}"
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

# TODO(cdutra): PAS

output "pas_subnet_name" {
  value = "${module.pas.pas_subnet_name}"
}

output "pas_subnet_cidr" {
  value = "${module.pas.pas_subnet_cidr}"
}

output "pas_subnet_gateway" {
  value = "${module.pas.pas_subnet_gateway}"
}

output "services_subnet_name" {
  value = "${module.pas.services_subnet_name}"
}

output "services_subnet_cidr" {
  value = "${module.pas.services_subnet_cidr}"
}

output "services_subnet_gateway" {
  value = "${module.pas.services_subnet_gateway}"
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

output "cf_storage_account_name" {
  value = "${module.pas.cf_storage_account_name}"
}

output "cf_storage_account_access_key" {
  sensitive = true
  value     = "${module.pas.cf_storage_account_access_key}"
}

output "cf_droplets_storage_container" {
  value = "${module.pas.cf_droplets_storage_container_name}"
}

output "cf_packages_storage_container" {
  value = "${module.pas.cf_packages_storage_container_name}"
}

output "cf_resources_storage_container" {
  value = "${module.pas.cf_resources_storage_container_name}"
}

output "cf_buildpacks_storage_container" {
  value = "${module.pas.cf_buildpacks_storage_container_name}"
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

output "isolation_segment" {
  value = {
    "lb_name" = "${module.isolation_segment.lb_name}"
  }
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

output "infrastructure_subnet_cidrs" {
  value = "${module.infra.infrastructure_subnet_cidrs}"
}

output "pas_subnet_cidrs" {
  value = "${module.pas.pas_subnet_cidrs}"
}

output "services_subnet_cidrs" {
  value = "${module.pas.services_subnet_cidrs}"
}

output "services_subnets" {
  value = ["${module.pas.services_subnet_name}"]
}

output "infrastructure_subnets" {
  value = ["${module.infra.infrastructure_subnet_name}"]
}

output "pas_subnets" {
  value = ["${module.pas.pas_subnet_name}"]
}
