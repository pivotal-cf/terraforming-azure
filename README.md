# Terraforming Azure [![build-status](https://infra.ci.cf-app.com/api/v1/teams/main/pipelines/terraforming-azure/jobs/deploy-pas/badge)](https://infra.ci.cf-app.com/teams/main/pipelines/terraforming-azure)

## How Does One Use This?

Please note that the master branch is generally *unstable*. If you are looking for something "tested", please consume one of our [releases](https://github.com/pivotal-cf/terraforming-azure/releases).

## What Does This Do?

Will go from zero to having a deployed ops-manager. You'll get networking, a storage account, and
a booted ops-manager VM.

## Looking to setup a different IAAS

We have other terraform templates to help you!

- [aws](https://github.com/pivotal-cf/terraforming-aws)
- [gcp](https://github.com/pivotal-cf/terraforming-gcp)

## Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [azure cli](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/)

```bash
brew update
brew install terraform
brew install az
brew install jq
```

## Creating A Service Principal

You need a [service principal account](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest#create-a-service-principal)
to deploy anything on top of Azure.

1. Login.

  ```bash
  $ az login
  $ az account show | jq -r '.id, .tenantId'
  the-subscription-id
  the-tenant-id
  ```

1. Create the service principal where the name is a valid URI.

  ```bash
  $ az ad sp create-for-rbac --name http://<service-principal-name> | jq -r '.appId, .password'
  the-app-id
  the-password
  ```

1. Create a `terraform.tfvars` file the following:
  ```hcl
  subscription_id = "the-subscription-id"
  tenant_id       = "the-tenant-id"
  client_id       = "the-app-id"
  client_secret   = "the-password"
  ```

## Deploying Ops Manager

Depending if you're deploying PAS or PKS you need to perform the following steps:

1. `cd` into the proper directory:
    - [terraforming-pas/](terraforming-pas/)
1. Create [`terraform.tfvars`](/README.md#var-file) file
1. Run terraform apply:
  ```bash
  terraform init
  terraform plan -out=plan
  terraform apply plan
  ```


### Var File

Copy the stub content below into a file called `terraform.tfvars` and put it in the root of this project.
These vars will be used when you run `terraform  apply`.
You should fill in the stub values with the correct content.

```hcl
subscription_id = "the-subscription-id"
tenant_id       = "the-tenant-id"
client_id       = "the-app-id"
client_secret   = "the-password"

env_name              = "banana"
ops_manager_image_uri = "url-to-opsman-image"
location              = "West US"
dns_suffix            = "domain.com"

# optional. if left blank, will default to the pattern `env_name.dns_suffix`.
dns_subdomain         = ""
```

## Variables

- env_name: **(required)** An arbitrary unique name for namespacing resources
- subscription_id: **(required)** Azure account subscription id
- tenant_id: **(required)** Azure account tenant id
- client_id: **(required)** Azure automation account client id
- client_secret: **(required)** Azure automation account client secret
- ops_manager_image_uri: **(optional)** URL for an OpsMan image hosted on Azure (if not provided you get no Ops Manager)
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

**Note:** This will only destroy resources deployed by Terraform. You will need to clean up anything deployed on top of that infrastructure yourself (e.g. by running `om delete-installation`)

```bash
terraform destroy
```
