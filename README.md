#How Does One Use This?

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

You need these credentials to deploy anything on top of azure. Before you can create an automation
account you must be able to log into the azure portal

run this command to get the azure account:

1. account *required* - your account id listed by running `azure accounts list`
2. credential-output-file *required* - credentials for your azure account will be written here

The file created as an output here should include information about the account credentials listed below.

```bash
bin/create-automation-account.sh --account 47B0A6EC-B2E5-4995-ACC1-E055AF0264E4 --credential-output-file some-credentials.tfvars
```

## Variables

- env_name: **(required)** An arbitrary unique name for namespacing resources
- env_short_name: **(required)** Used for creating storage accounts. Must be a-z only, no longer than 10 characters
- subscription_id: **(required)** Azure account subscription id
- tenant_id: **(required)** Azure account tenant id
- client_id: **(required)** Azure automation account client id
- client_secret: **(required)** Azure automation account client secret
- ops_manager_image_uri: **(required)** URL for an OpsMan image hosted on Azure
- location: **(required)** Azure location to stand up environment in
- vm_admin_username: **(required)** Admin username for OpsMan VM
- vm_admin_password: **(required)** Admin password for OpsMan VM
- vm_admin_public_key: **(required)** SSH public key for OpsMan VM
- vm_admin_private_key: **(required)** SSH private key for OpsMan VM
- dns_suffix: **(required)** Domain to add environment subdomain to

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
  -var "vm_admin_public_key=admin-public-key" \
  -var "vm_admin_private_key=admin-private-key" \
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
  -var "vm_admin_public_key=admin-public-key" \
  -var "vm_admin_private_key=admin-private-key" \
  -var "dns_suffix=some.domain.com"
```

## Troubleshooting

We have found terraform to not provide good error outputs. The audit logs in the Azure Portal
are very helpful.
