data "template_file" "subnets" {
  count = "${length(var.iso_seg_names)}"
  template = "${cidrhost(azurerm_subnet.iso_seg_subnet.*.address_prefix[count.index], 1)}"
}

output "subnet_names" {
  value = "${azurerm_subnet.iso_seg_subnet.*.name}"
}

output "subnet_cidrs" {
  value = "${azurerm_subnet.iso_seg_subnet.*.address_prefix}"
}

output "subnet_gateways" {
  value = ["${join(",", data.template_file.subnets.*.rendered)}"]
}

output "lb_names" {
  value = "${azurerm_lb.iso.*.name}"
}

output "ssl_cert" {
  sensitive = true
  value     = "${length(var.ssl_ca_cert) > 0 ? element(concat(tls_locally_signed_cert.ssl_cert.*.cert_pem, list("")), 0) : var.ssl_cert}"
}

output "ssl_private_key" {
  sensitive = true
  value     = "${length(var.ssl_ca_cert) > 0 ? element(concat(tls_private_key.ssl_private_key.*.private_key_pem, list("")), 0) : var.ssl_private_key}"
}
