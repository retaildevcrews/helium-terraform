# Infrastructure as Code for `helium`

> This repository is used to automatically deploy [helium](https://github.com/retaildevcrews/helium) using [terraform](https://www.hashicorp.com/products/terraform)

![License](https://img.shields.io/badge/license-MIT-green.svg)
![Terraform Plan](https://github.com/retaildevcrews/helium-iac/workflows/Terraform%20Plan/badge.svg)

## Change Log

- updated to use same He_* env vars as manual setup
  - keys use HE_* in the TF file so they don't get saved via saveenv.sh
  - added He_Location sed
  - changed from He_Language to He_Repo for consistency
  - added He_Repo sed
- fixed ACR import bug
- added He_Name preface to tfstate-rg
- standardized casing / naming in dashboard / alerts

## TODO

- Web Deploy
  - the image is pulled from docker hub
    - pull image from ACR using Key Vault credentials
  - ACR ci-cd webhook isn't setup - need to test
  - docker container logging isn't enabled

- dash.tpl line 718 - "INSERT LOCATION" - should this be a replacement value?

- module readme files need to be updated and regenerated

- wait for web app before creating web test
- wait for acr import before creating acr web hook
- wait for web app before creating acr hook?

- should the tf state RG be created with the same TF script? A tf destroy will delete the state
- how do the state files get copied to Azure? there is no storage account created

- Should we add webv deployment to manual instructions for consistency?

- need to test dashboard and alerts to make sure they are the same between manual setup and terraform setup

- option to deploy to AKS is missing (I think this is OK - especially for this release)

## Fixed in this branch

- I had to run imdb-import manually to get webv to pass
  - this now runs syncronously and blocks web
- web app throws errors due to timing
  - waits for imdb-import
  - this blocks smoker
- smoker throws errors due to timing
  - waits for imdb-import and web deploy

- the image is pulled from docker hub
  - should be loaded into ACR (done)
  - will need an additional SP (done)
  - will need ACR pull permissions on the SP (done)

- now uses standard He_Name url
- standardized names to manual install

## Features

- one ACR
- one docker hub repo
- one app service plan
- 3 web apps (API)
- one AKS Cluster
- WebV running in ACI to test App Service endpoints
- one CosmosDB
- 1 Databases
- 2 app insights (one for WebV)
- 1 key vaults
- standardize endpoints
  - AppSvc endpoints: $He_Name.azurewebsites.net
- standardize dashboard
- standardize Azure health check
- standardize alerting

> Visual Studio Codespaces is the easiest way to evaluate helium as all of the prerequisites are automatically installed
>
> Follow the setup steps in the [Helium readme](https://github.com/retaildevcrews/helium) to setup Codespaces

## Prerequisites

- Azure subscription and a Service Principal permissions to create:
  - Resource Groups, Service Principals, Role Assignment, Key Vault, Cosmos DB, Azure Container Registry, Azure Monitor, App Service or AKS (Subscription Owner Role)
- Bash shell (tested on Visual Studio Codespaces, Mac, Ubuntu, Windows with WSL2)
  - Will not work in Cloud Shell or WSL1
- Azure CLI ([download](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest))
- Terraform 0.12+ ([download](https://www.terraform.io/downloads.html))
- Docker must be installed and running ([download](https://docs.docker.com/get-docker/))

## Setup

```bash

# Clone the Helium-IAC repo if not using Codespaces
git clone https://github.com/retaildevcrews/helium-iac.git

cd helium-iac/src/root

```

### Login to Azure and select subscription

```bash

az login

# show your Azure accounts
az account list -o table

# select the Azure subscription if necessary
az account set -s {subscription name or Id}

```

### Prepare your `terraform.tfvars` file to roll out resources in the subscription of your choice

> All commands require you to be in `helium-iac/src/root`

```bash

### TODO - do we need a warning here to make sure He_Name doesn't exist?
### BAD things happen if it does ...
### should we check RG names? Cosmos DB? Other?
### probably easiest to do the first few steps from helium and then do these steps
### we could use the same He_* names and the check vs. having to maintain in two places
### right now, we don't clone helium, we clone helium-language
### maybe we put the shipping version in helium with instructions?
### would need two repos in codespaces, but shouldn't be an issue - will need a design review

# set an env var with the name you want to use
# replace the two values below
# He_Name must contain only alphanumeric characters and is a prefix for other resources

export He_Name=replaceWithYourUniqueName
export He_Email=replaceWithYourEmail

# change the location (optional)
export He_Location=centralus

# change the repo (optional - valid: helium-csharp, helium-java, helium-typescript)
export He_Repo=helium-csharp

# create terraform.tfvars and replace placeholder values
# replace He_Name
cat ../example.tfvars | sed "s/<<He_Name>>/$He_Name/g" > terraform.tfvars

# replace email
sed -i "s/<<He_Location>>/$He_Location/g" terraform.tfvars

# replace repo
sed -i "s/<<He_Repo>>/$He_Repo/g" terraform.tfvars

# replace email
sed -i "s/<<He_Email>>/$He_Email/g" terraform.tfvars

# replace TF_TENANT_ID
sed -i "s/<<HE_TENANT_ID>>/$(az account show -o tsv --query tenantId)/g" terraform.tfvars

# replace TF_SUB_ID
sed -i "s/<<HE_SUB_ID>>/$(az account show -o tsv --query id)/g" terraform.tfvars

# create a service principal
# replace TF_CLIENT_SECRET
sed -i "s/<<HE_CLIENT_SECRET>>/$(az ad sp create-for-rbac -n http://${He_Name}-tf-sp --query password -o tsv)/g" terraform.tfvars

# replace TF_CLIENT_ID
sed -i "s/<<HE_CLIENT_ID>>/$(az ad sp show --id http://${He_Name}-tf-sp --query appId -o tsv)/g" terraform.tfvars

# create a service principal
# replace ACR_SP_SECRET
sed -i "s/<<HE_ACR_SP_SECRET>>/$(az ad sp create-for-rbac -n http://${He_Name}-acr-sp --query password -o tsv)/g" terraform.tfvars

# replace ACR_SP_ID
sed -i "s/<<HE_ACR_SP_ID>>/$(az ad sp show --id http://${He_Name}-acr-sp --query objectId -o tsv)/g" terraform.tfvars

# validate the substitutions
cat terraform.tfvars

```

## Location

Optionally edit terraform.tfvars and replace `centralus` with a different location

## Deploy `helium`

``` bash

# Initialize your terraform providers:
terraform init

# Format your terraform files:
terraform fmt -recursive

# Validate the terraform code is ready to apply:
terraform validate

# If you have no errors you can create the resources
# You must answer "yes" to 'Enter a value:' to create the resources
terraform apply

```

## Verify the deployment

Log into the Azure portal and browse your three new resource groups

> TODO - should we have CLI commands for this? like curl, http, webv
>
> TODO - docs on the `terraform.tfstate` file - security, where to store, etc.
>
> If the terraform plan command is redirected to a file, there will be secrets stored in that file!
>
> Be sure to not to remove the ignore *tfplan* in the .gitignore file

## Module Documentation

Each module has a `README.md` file in the module directory under [`./src/modules/`](./src/modules/). You can reference the module documentation for the specific requirements of each module.

The main calling Terraform script can be found at [`./src/root/main.tf`](./src/root/main.tf)

Customizations are found in the /src/root/terraform.tfvars file.  This file should never be added to github and is included by default in the .gitignore file.

## Removing the deployment

>
> WARNING - this will delete everything with only one prompt
>

```bash

# this takes several minutes to run
terraform destroy

# delete the service principals
az ad sp delete --id http://${He_Name}-acr-sp
az ad sp delete --id http://${He_Name}-tf-sp

# remove state and vars files
rm terraform.tfstate*
rm terraform.tfvars

```

## Contributing

This project welcomes contributions and suggestions. Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit [Microsoft Contributor License Agreement](https://cla.opensource.microsoft.com).

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
