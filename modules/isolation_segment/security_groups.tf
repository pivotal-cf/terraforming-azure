# https://docs.pivotal.io/pivotalcf/2-3/adminguide/routing-is.html#config-firewall
# shared-to-bosh - in infra module
# bosh-to-shared  - in infra module
# shared-internal - in infra module

resource "azurerm_network_security_group" "iso_segment_vms" {
  name                = "${var.env_name}-iso-seg-${element(var.iso_seg_names, count.index)}-security-group" 
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  count               = "${length(var.iso_seg_names)}"

  # Diego BBS in shared PAS subnet to reach cells in iso segment(s)
  security_rule {
    name                       = "shared-to-iso"
    priority                   = 998
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = [
      "1801", # rep.diego.rep.listen_addr_securable
      "8853"  # bosh-dns.health.server.port
    ]
    source_address_prefix      = "${var.pas_subnet_cidr}"
    destination_address_prefix = "${element(var.iso_seg_subnets, count.index)}"
  }

  # Deny traffic from PAS subnet to iso segment(s) on all ports
  security_rule {
    name                       = "shared-to-iso-deny"
    priority                   = 999
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${var.pas_subnet_cidr}"
    destination_address_prefix = "${element(var.iso_seg_subnets, count.index)}"
  }

  # BOSH agent on VMs in iso segment(s) to reach BOSH Director
  # See:
  #   https://github.com/cloudfoundry/docs-cf-admin/pull/124
  #   https://github.com/cloudfoundry/bosh-deployment#security-groups
  security_rule {
    name                       = "iso-to-bosh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = [
      "4222",  # NATS
      "25250", # Blobstore
      "25777"  # Registry
    ]
    source_address_prefix      = "${element(var.iso_seg_subnets, count.index)}"
    destination_address_prefix = "${var.infra_subnet_cidr}"
  }

  # Deny traffic from iso segment(s) to BOSH infra subnet
  security_rule {
    name                       = "iso-to-bosh-deny"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${element(var.iso_seg_subnets, count.index)}"
    destination_address_prefix = "${var.infra_subnet_cidr}"
  }

  # BOSH director to control VMs in iso segment(s)
  security_rule {
    name                       = "bosh-to-iso"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${var.infra_subnet_cidr}"
    destination_address_prefix = "${element(var.iso_seg_subnets, count.index)}"
  }

  # VMs within isolation segment to reach one another
  security_rule {
    name                       = "iso-internal"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${element(var.iso_seg_subnets, count.index)}"
    destination_address_prefix = "${element(var.iso_seg_subnets, count.index)}"
  }

  # Diego Cells in isolation segment(s) to reach BBS, Auctioneer, and CredHub in PAS subnet
  # Metron Agent in isolation segment(s) to reach Traffic Controller in PAS subnet
  # Routers in isolation segment(s) to reach NATS, UAA, and Routing API in PAS subnet
  security_rule {
    name                       = "iso-to-shared"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = [
      "9090", # CC Uploader, http_port
      "9091", # CC Uploader, https_port
      "8082", # Doppler gRPC, loggregator.doppler.grpc_port
      "8300", # Consul server port
      "8301", # Consul serf lan port
      "8302", # Consul serf wan port
      "8889", # Diego BBS, diego.rep.bbs.api_location
      "8443", # UAA, uaa.ssl.port
      "3000", # Routing API, routing_api.port
      "4443", # blobstore.blobstore.tls.port
      "8080", # blobstore.blobstore.port, file_server.diego.file_server.listen_addr (PAS only)
      "3457", # Doppler, metron_endpoint.dropsonde_port
      "9023", # CC TPS, capi.tps.cc.external_port
      "9022", # CC Stager, capi.stager.cc.external_port
      "4222", # NATS, router.nats.port
      "8844", # CredHub, credhub.port
      "8853", # BOSH DNS health, health.server.port from bosh-dns-release
      "4003", # VXLAN Policy Agent, cf_networking.policy_server.internal_listen_port
      "4103", # Silk Controller, cf_networking.silk_controller.listen_port
      "8082", # Doppler gRPC, loggregator.doppler.grpc_port
      "8891"  # Diego DB, diego.locket.listen_addr
    ]
    source_address_prefix      = "${element(var.iso_seg_subnets, count.index)}"
    destination_address_prefix = "${var.pas_subnet_cidr}"
  }

  # Diego Cells in isolation segment(s) to reach Consul in PAS subnet via UDP
  security_rule {
    name                       = "iso-to-shared-udp"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_ranges    = [
      "8301", # Consul serf LAN port
      "8302", # Consul serf WAN port
      "8600"  # Consul DNS
    ]
    source_address_prefix      = "${element(var.iso_seg_subnets, count.index)}"
    destination_address_prefix = "${var.pas_subnet_cidr}"
  }

  # Deny traffic from iso segment(s) to PAS subnet
  security_rule {
    name                       = "iso-to-shared-deny"
    priority                   = 1006
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${element(var.iso_seg_subnets, count.index)}"
    destination_address_prefix = "${var.pas_subnet_cidr}"
  }
}
