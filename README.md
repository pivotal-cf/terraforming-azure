# How Does One Use This?

Please note that the master branch is generally *unstable*. If you are looking for something "tested", please consume one of our [releases](https://github.com/pivotal-cf/terraforming-azure/releases).

## What Does This Do?

Will go from zero to having a deployed ops-manager. You'll get networking, a storage account, and
a booted ops-manager VM.

## Looking to setup a different IAAS

We have have other terraform templates to help you!

- [aws](https://github.com/pivotal-cf/terraforming-aws)
- [gcp](https://github.com/pivotal-cf/terraforming-gcp)

## Prerequisites

```bash
go get -u github.com/hashicorp/terraform
```

## Creating An Automation Account

You need an automation account to deploy anything on top of Azure. However, before you can create an automation
account you must be able to log into the Azure portal.

First, find your account by running the following commands using the [Azure CLI](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/):
```bash
azure login
azure account list
```

You can then run the script located at `bin/create-automation-account.sh`. An example can be seen here:
```bash
./bin/create-automation-account.sh \
  --account some-account-id \
  --identifier-uri http://example.com \
  --display-name some-display-name \
  --credential-output-file some-credentials.tfvars
```

The file created as an output here should include the following:
```hcl
subscription_id = "some-subscription-id"
tenant_id       = "some-tenant-id"
client_id       = "some-client-id"
client_secret   = "some-client-secret"
```

## Variables

- env_name: **(required)** An arbitrary unique name for namespacing resources
- env_short_name: **(required)** Used for creating storage accounts. Must be a-z only,
no longer than 10 characters
- subscription_id: **(required)** Azure account subscription id
- tenant_id: **(required)** Azure account tenant id
- client_id: **(required)** Azure automation account client id
- client_secret: **(required)** Azure automation account client secret
- ops_manager_image_uri: **(required)** URL for an OpsMan image hosted on Azure
- location: **(required)** Azure location to stand up environment in
- vm_admin_username: **(required)** Admin username for OpsMan VM
- vm_admin_password: **(required)** Admin password for OpsMan VM
- dns_suffix: **(required)** Domain to add environment subdomain to

### Optional

When deploying the isolation segments tile you can optionally route traffic through
a separate domain and load balancer by specifying:

- create_isoseg_resources: **(default 0)** Creates a DNS record and load balancer for
isolation segment network traffic when set to 1

## Running

### Standing up environment

```bash
terraform apply \
  -var "env_name=banana" \
  -var "env_short_name=banana" \
  -var "subscription_id=azure-subscription-id" \
  -var "tenant_id=azure-tenant-id" \
  -var "client_id=azure-client-id" \
  -var "client_secret=azure-client-secret" \
  -var "ops_manager_image_uri=url-to-opsman-image" \
  -var "location=westus" \
  -var "vm_admin_username=admin-username" \
  -var "vm_admin_password=admin-password" \
  -var "dns_suffix=some.domain.com"
```

### Tearing down environment

```bash
terraform destroy \
  -var "env_name=banana" \
  -var "env_short_name=banana" \
  -var "subscription_id=azure-subscription-id" \
  -var "tenant_id=azure-tenant-id" \
  -var "client_id=azure-client-id" \
  -var "client_secret=azure-client-secret" \
  -var "ops_manager_image_uri=url-to-opsman-image" \
  -var "location=westus" \
  -var "vm_admin_username=admin-username" \
  -var "vm_admin_password=admin-password" \
  -var "dns_suffix=some.domain.com"
```

## Troubleshooting

We have found terraform to not provide good error outputs. The audit logs in the Azure Portal
are very helpful.
