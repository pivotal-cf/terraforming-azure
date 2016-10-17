resource "azurerm_template_deployment" "load_balancers" {
  name                = "${var.env_name}-load-balancers"
  depends_on          = ["azurerm_dns_zone.env_dns_zone"]
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"
  template_body       = "${data.template_file.load_balancers.rendered}"
  deployment_mode     = "Incremental"
}

data "template_file" "load_balancers" {
  vars {
    location                = "${var.location}"
    env_name                = "${var.env_name}"
    mysql_lb_name           = "${var.env_name}-mysql-lb"
    mysql_lb_public_ip_name = "${var.env_name}-mysql-lb-public-ip"
    tcp_lb_name             = "${var.env_name}-tcp-lb"
    tcp_lb_public_ip_name   = "${var.env_name}-tcp-lb-public-ip"
    dns_zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  }

  template = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "name": "${mysql_lb_public_ip_name}",
      "apiVersion": "2016-03-30",
      "location": "${location}",
      "properties": {
        "publicIPAllocationMethod": "Static",
        "idleTimeoutInMinutes": 4,
        "dnsSettings": {
          "domainNameLabel": "${mysql_lb_public_ip_name}"
        }
      }
    },
    {
      "type": "Microsoft.Network/loadBalancers",
      "name": "${mysql_lb_name}",
      "apiVersion": "2016-03-30",
      "location": "${location}",
      "dependsOn": [
        "[resourceId('Microsoft.Network/publicIPAddresses', '${mysql_lb_public_ip_name}')]"
      ],
      "properties": {
        "frontendIPConfigurations": [
          {
            "name": "frontendip",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "publicIPAddress": { "id": "[resourceId('Microsoft.Network/publicIPAddresses', '${mysql_lb_public_ip_name}')]" }
            }
          }
        ],
        "backendAddressPools": [ { "name": "backendpool" } ],
        "loadBalancingRules": [
          {
            "name": "MYSQL",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${mysql_lb_name}', 'frontendip')]" },
              "frontendPort": 3306,
              "backendPort": 3306,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${mysql_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${mysql_lb_name}', 'MYSQL')]" }
            }
          }
        ],
        "probes": [
          { "name": "MYSQL", "properties": { "protocol": "Tcp", "port": 1936, "intervalInSeconds": 5, "numberOfProbes": 2 } }
        ]
      }
    },
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "name": "${tcp_lb_public_ip_name}",
      "apiVersion": "2016-03-30",
      "location": "${location}",
      "properties": {
        "publicIPAllocationMethod": "Static",
        "idleTimeoutInMinutes": 4,
        "dnsSettings": {
          "domainNameLabel": "${tcp_lb_public_ip_name}"
        }
      }
    },
    {
      "type": "Microsoft.Network/loadBalancers",
      "name": "${tcp_lb_name}",
      "apiVersion": "2016-03-30",
      "location": "${location}",
      "dependsOn": [
        "[resourceId('Microsoft.Network/publicIPAddresses', '${tcp_lb_public_ip_name}')]"
      ],
      "properties": {
        "frontendIPConfigurations": [
          {
            "name": "frontendip",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "publicIPAddress": { "id": "[resourceId('Microsoft.Network/publicIPAddresses', '${tcp_lb_public_ip_name}')]" }
            }
          }
        ],
        "backendAddressPools": [ { "name": "backendpool" } ],
        "loadBalancingRules": [
          {
            "name": "TCP_1024",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1024,
              "backendPort": 1024,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1025",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1025,
              "backendPort": 1025,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1026",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1026,
              "backendPort": 1026,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1027",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1027,
              "backendPort": 1027,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1028",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1028,
              "backendPort": 1028,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1029",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1029,
              "backendPort": 1029,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1030",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1030,
              "backendPort": 1030,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1031",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1031,
              "backendPort": 1031,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1032",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1032,
              "backendPort": 1032,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1033",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1033,
              "backendPort": 1033,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1034",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1034,
              "backendPort": 1034,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1035",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1035,
              "backendPort": 1035,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1036",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1036,
              "backendPort": 1036,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1037",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1037,
              "backendPort": 1037,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1038",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1038,
              "backendPort": 1038,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1039",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1039,
              "backendPort": 1039,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1040",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1040,
              "backendPort": 1040,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1041",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1041,
              "backendPort": 1041,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1042",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1042,
              "backendPort": 1042,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1043",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1043,
              "backendPort": 1043,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1044",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1044,
              "backendPort": 1044,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1045",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1045,
              "backendPort": 1045,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1046",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1046,
              "backendPort": 1046,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1047",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1047,
              "backendPort": 1047,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1048",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1048,
              "backendPort": 1048,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1049",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1049,
              "backendPort": 1049,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1050",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1050,
              "backendPort": 1050,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1051",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1051,
              "backendPort": 1051,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1052",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1052,
              "backendPort": 1052,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1053",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1053,
              "backendPort": 1053,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1054",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1054,
              "backendPort": 1054,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1055",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1055,
              "backendPort": 1055,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1056",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1056,
              "backendPort": 1056,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1057",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1057,
              "backendPort": 1057,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1058",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1058,
              "backendPort": 1058,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1059",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1059,
              "backendPort": 1059,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1060",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1060,
              "backendPort": 1060,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1061",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1061,
              "backendPort": 1061,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1062",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1062,
              "backendPort": 1062,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1063",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1063,
              "backendPort": 1063,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1064",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1064,
              "backendPort": 1064,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1065",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1065,
              "backendPort": 1065,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1066",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1066,
              "backendPort": 1066,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1067",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1067,
              "backendPort": 1067,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1068",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1068,
              "backendPort": 1068,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1069",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1069,
              "backendPort": 1069,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1070",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1070,
              "backendPort": 1070,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1071",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1071,
              "backendPort": 1071,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1072",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1072,
              "backendPort": 1072,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1073",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1073,
              "backendPort": 1073,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1074",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1074,
              "backendPort": 1074,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1075",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1075,
              "backendPort": 1075,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1076",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1076,
              "backendPort": 1076,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1077",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1077,
              "backendPort": 1077,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1078",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1078,
              "backendPort": 1078,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1079",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1079,
              "backendPort": 1079,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1080",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1080,
              "backendPort": 1080,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1081",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1081,
              "backendPort": 1081,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1082",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1082,
              "backendPort": 1082,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1083",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1083,
              "backendPort": 1083,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1084",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1084,
              "backendPort": 1084,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1085",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1085,
              "backendPort": 1085,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1086",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1086,
              "backendPort": 1086,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1087",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1087,
              "backendPort": 1087,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1088",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1088,
              "backendPort": 1088,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1089",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1089,
              "backendPort": 1089,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1090",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1090,
              "backendPort": 1090,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1091",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1091,
              "backendPort": 1091,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1092",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1092,
              "backendPort": 1092,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1093",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1093,
              "backendPort": 1093,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1094",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1094,
              "backendPort": 1094,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1095",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1095,
              "backendPort": 1095,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1096",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1096,
              "backendPort": 1096,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1097",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1097,
              "backendPort": 1097,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1098",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1098,
              "backendPort": 1098,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1099",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1099,
              "backendPort": 1099,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1100",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1100,
              "backendPort": 1100,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1101",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1101,
              "backendPort": 1101,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1102",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1102,
              "backendPort": 1102,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1103",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1103,
              "backendPort": 1103,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1104",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1104,
              "backendPort": 1104,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1105",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1105,
              "backendPort": 1105,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1106",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1106,
              "backendPort": 1106,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1107",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1107,
              "backendPort": 1107,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1108",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1108,
              "backendPort": 1108,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1109",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1109,
              "backendPort": 1109,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1110",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1110,
              "backendPort": 1110,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1111",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1111,
              "backendPort": 1111,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1112",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1112,
              "backendPort": 1112,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1113",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1113,
              "backendPort": 1113,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1114",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1114,
              "backendPort": 1114,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1115",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1115,
              "backendPort": 1115,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1116",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1116,
              "backendPort": 1116,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1117",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1117,
              "backendPort": 1117,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1118",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1118,
              "backendPort": 1118,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1119",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1119,
              "backendPort": 1119,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1120",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1120,
              "backendPort": 1120,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1121",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1121,
              "backendPort": 1121,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1122",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1122,
              "backendPort": 1122,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1123",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1123,
              "backendPort": 1123,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1124",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1124,
              "backendPort": 1124,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1125",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1125,
              "backendPort": 1125,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1126",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1126,
              "backendPort": 1126,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1127",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1127,
              "backendPort": 1127,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1128",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1128,
              "backendPort": 1128,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1129",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1129,
              "backendPort": 1129,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1130",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1130,
              "backendPort": 1130,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1131",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1131,
              "backendPort": 1131,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1132",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1132,
              "backendPort": 1132,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1133",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1133,
              "backendPort": 1133,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1134",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1134,
              "backendPort": 1134,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1135",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1135,
              "backendPort": 1135,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1136",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1136,
              "backendPort": 1136,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1137",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1137,
              "backendPort": 1137,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1138",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1138,
              "backendPort": 1138,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1139",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1139,
              "backendPort": 1139,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1140",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1140,
              "backendPort": 1140,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1141",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1141,
              "backendPort": 1141,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1142",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1142,
              "backendPort": 1142,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1143",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1143,
              "backendPort": 1143,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1144",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1144,
              "backendPort": 1144,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1145",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1145,
              "backendPort": 1145,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1146",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1146,
              "backendPort": 1146,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1147",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1147,
              "backendPort": 1147,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1148",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1148,
              "backendPort": 1148,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1149",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1149,
              "backendPort": 1149,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1150",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1150,
              "backendPort": 1150,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1151",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1151,
              "backendPort": 1151,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1152",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1152,
              "backendPort": 1152,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1153",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1153,
              "backendPort": 1153,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1154",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1154,
              "backendPort": 1154,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1155",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1155,
              "backendPort": 1155,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1156",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1156,
              "backendPort": 1156,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1157",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1157,
              "backendPort": 1157,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1158",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1158,
              "backendPort": 1158,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1159",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1159,
              "backendPort": 1159,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1160",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1160,
              "backendPort": 1160,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1161",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1161,
              "backendPort": 1161,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1162",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1162,
              "backendPort": 1162,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1163",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1163,
              "backendPort": 1163,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1164",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1164,
              "backendPort": 1164,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1165",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1165,
              "backendPort": 1165,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1166",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1166,
              "backendPort": 1166,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1167",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1167,
              "backendPort": 1167,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1168",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1168,
              "backendPort": 1168,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1169",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1169,
              "backendPort": 1169,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1170",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1170,
              "backendPort": 1170,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1171",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1171,
              "backendPort": 1171,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1172",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1172,
              "backendPort": 1172,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          },
          {
            "name": "TCP_1173",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${tcp_lb_name}', 'frontendip')]" },
              "frontendPort": 1173,
              "backendPort": 1173,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${tcp_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${tcp_lb_name}', 'TCP')]" }
            }
          }
        ],
        "probes": [
          { "name": "TCP", "properties": { "protocol": "Tcp", "port": 80, "intervalInSeconds": 5, "numberOfProbes": 2 } }
        ]
      }
    }
  ]
}
TEMPLATE
}
