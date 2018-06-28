# How Does One Use This?

Please note that the master branch is generally *unstable*. If you are looking for something "tested", please consume one of our [releases](https://github.com/pivotal-cf/terraforming-azure/releases).

## What Does This Do?

Will go from zero to having a deployed ops-manager. You'll get networking, a storage account, and
a booted ops-manager VM.

## Looking to setup a different IAAS

We have other terraform templates to help you!

- [aws](https://github.com/pivotal-cf/terraforming-aws)
- [gcp](https://github.com/pivotal-cf/terraforming-gcp)

## Prerequisites

```bash
brew update
brew install terraform
```

## Creating An Automation Account

You need an automation account to deploy anything on top of Azure. However, before you can create an automation
account you must be able to log into the Azure portal.

First, find your account by running the following commands using the [Azure CLI](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/):
```bash
azure login
azure account list
```

To create the automation account, you need `az-automation`. You can use brew or
go to the [releases](https://github.com/genevieve/az-automation/releases)
and get the necessary binary.

```
brew tap genevieve/tap
brew install az-automation
```

Then run:

```bash
az-automation \
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

### Var File

Copy the stub content below into a file called `terraform.tfvars` and put it in the root of this project.
These vars will be used when you run `terraform  apply`.
You should fill in the stub values with the correct content.

```hcl
subscription_id = "some-subscription-id"
tenant_id       = "some-tenant-id"
client_id       = "some-client-id"
client_secret   = "some-client-secret"

env_name              = "banana"
env_short_name        = "banana"
ops_manager_image_uri = "url-to-opsman-image"
location              = "West US"
dns_suffix            = "domain.com"

# optional. if left blank, will default to "pcf".
dns_subdomain         = ""
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
- dns_suffix: **(required)** Domain to add environment subdomain to

### Optional

When deploying the isolation segments tile you can optionally route traffic through
a separate domain and load balancer by specifying:

- isolation_segment: **(default false)** Creates a DNS record and load balancer for
isolation segment network traffic when set to true.

## Running

Note: please make sure you have created the `terraform.tfvars` file above as mentioned.

### Standing up environment

```bash
terraform init
terraform plan -out=plan
terraform apply plan
```

### Tearing down environment

```bash
terraform destroy
```
