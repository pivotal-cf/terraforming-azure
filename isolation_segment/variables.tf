variable "count" {}

variable "location" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "resource_group_name" {
  type = "string"
}

variable "dns_zone" {
  type = "string"
}

variable "ssl_cert" {
  type        = "string"
  description = "the contents of an SSL certificate which should be passed to the isoseg gorouter, optional if `ssl_ca_cert` is provided"
  default     = ""
}

variable "ssl_private_key" {
  type        = "string"
  description = "the contents of an SSL private key which should be passed to the isoseg gorouter, optional if `ssl_ca_cert` is provided"
  default     = ""
}

variable "ssl_ca_cert" {
  type        = "string"
  description = "the contents of a CA public key to be used to sign a generated certificate for isoseg gorouter, optional if `ssl_cert` is provided"
  default     = ""
}

variable "ssl_ca_private_key" {
  type        = "string"
  description = "the contents of a CA private key to be used to sign a generated certificate for isoseg gorouter, optional if `ssl_cert` is provided"
  default     = ""
}
