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
    web_lb_name             = "${var.env_name}-web-lb"
    web_lb_public_ip_name   = "${var.env_name}-web-lb-public-ip"
    mysql_lb_name           = "${var.env_name}-mysql-lb"
    mysql_lb_public_ip_name = "${var.env_name}-mysql-lb-public-ip"
    dns_zone_name           = "${azurerm_dns_zone.env_dns_zone.name}"
  }

  template = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "name": "${web_lb_public_ip_name}",
      "apiVersion": "2016-03-30",
      "location": "${location}",
      "properties": {
        "publicIPAllocationMethod": "Static",
        "idleTimeoutInMinutes": 4,
        "dnsSettings": {
          "domainNameLabel": "${web_lb_public_ip_name}"
        }
      }
    },
    {
      "type": "Microsoft.Network/loadBalancers",
      "name": "${web_lb_name}",
      "apiVersion": "2016-03-30",
      "location": "${location}",
      "dependsOn": [
        "[resourceId('Microsoft.Network/publicIPAddresses', '${web_lb_public_ip_name}')]"
      ],
      "properties": {
        "frontendIPConfigurations": [
          {
            "name": "frontendip",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "publicIPAddress": { "id": "[resourceId('Microsoft.Network/publicIPAddresses', '${web_lb_public_ip_name}')]" }
            }
          }
        ],
        "backendAddressPools": [ { "name": "backendpool" } ],
        "loadBalancingRules": [
          {
            "name": "HTTPS",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${web_lb_name}', 'frontendip')]" },
              "frontendPort": 443,
              "backendPort": 443,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${web_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${web_lb_name}', 'HTTPS')]" }
            }
          },
          {
            "name": "HTTP",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${web_lb_name}', 'frontendip')]" },
              "frontendPort": 80,
              "backendPort": 80,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${web_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${web_lb_name}', 'HTTP')]" }
            }
          },
          {
            "name": "SSH",
            "properties": {
              "frontendIPConfiguration": { "id": "[resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${web_lb_name}', 'frontendip')]" },
              "frontendPort": 2222,
              "backendPort": 2222,
              "enableFloatingIP": false,
              "idleTimeoutInMinutes": 4,
              "protocol": "Tcp",
              "loadDistribution": "Default",
              "backendAddressPool": { "id": "[resourceId('Microsoft.Network/loadBalancers/backendAddressPools', '${web_lb_name}', 'backendpool')]" },
              "probe": { "id": "[resourceId('Microsoft.Network/loadBalancers/probes', '${web_lb_name}', 'SSH')]" }
            }
          }
        ],
        "probes": [
          { "name": "SSH", "properties": { "protocol": "Tcp", "port": 2222, "intervalInSeconds": 5, "numberOfProbes": 2 } },
          { "name": "HTTPS", "properties": { "protocol": "Tcp", "port": 443, "intervalInSeconds": 5, "numberOfProbes": 2 } },
          { "name": "HTTP", "properties": { "protocol": "Tcp", "port": 80, "intervalInSeconds": 5, "numberOfProbes": 2 } }
        ]
      }
    },
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
    }
  ]
}
TEMPLATE
}
