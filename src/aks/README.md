# Setup AKS with pod identity

## Setup

```bash

# Clone this repo if not using Codespaces
git clone https://github.com/retaildevcrews/helium-terraform

cd helium-terraform/src/aks

```

### Choose a unique DNS name

```bash

# this will be the prefix for all resources
# only use a-z and 0-9 - do not include punctuation or uppercase characters
# must be at least 5 characters long
# must start with a-z (only lowercase)
He_Name=[your unique name]

### if true, change He_Name
az cosmosdb check-name-exists -n ${He_Name}

### if nslookup doesn't fail to resolve, change He_Name
nslookup ${He_Name}.vault.azure.net
nslookup ${He_Name}.azurecr.io

```

### Set additional values

```bash

# Set location for resources
He_Location=centralus

```

### Setup terraform backend

```bash

# tenant id of the account
HE_TENANT_ID=$(az account show -o tsv --query tenantId)

# current subscription id
HE_SUB_ID=$(az account show -o tsv --query id)

# create service principal for terraform
HE_CLIENT_SECRET=$(az ad sp create-for-rbac -n http://${He_Name}-tf-sp --query password -o tsv)

# client id of terraform service principal
HE_CLIENT_ID=$(az ad sp show --id http://${He_Name}-tf-sp --query appId -o tsv)

# create terraform resource group
TFSTATE_RG_NAME=$He_Name-rg-tf
az group create --name ${TFSTATE_RG_NAME} --location ${He_Location} -o table

# set a name for the terraform storage account
# must be a unique name across all of azure.
TFSA_NAME=tfstate$He_Name

# create storage account for terraform state file
az storage account create --resource-group $TFSTATE_RG_NAME --name $TFSA_NAME --sku Standard_LRS --encryption-services blob -o table

# storage account access key
ARM_ACCESS_KEY=$(az storage account keys list --resource-group $TFSTATE_RG_NAME --account-name $TFSA_NAME --query [0].value -o tsv)

# create storage account container
TFSA_CONTAINER="container${TFSA_NAME}"
az storage container create --name $TFSA_CONTAINER --account-name $TFSA_NAME --account-key $ARM_ACCESS_KEY -o table

```

### Create terraform config files

```bash

# save terraform backend definition
cat <<EOF > ./main_tf_state.tf
terraform {
  required_version = ">= 0.13"
  backend "azurerm" {
    resource_group_name  = "$TFSTATE_RG_NAME"
    storage_account_name = "$TFSA_NAME"
    container_name       = "$TFSA_CONTAINER"
    key                  = "prod.terraform.tfstate"
  }
}
EOF

# save terraform variables
cat <<EOF > ./terraform.tfvars
LOCATION         = "$He_Location"
NAME             = "$He_Name"
TF_CLIENT_ID     = "$HE_CLIENT_ID"
TF_CLIENT_SECRET = "$HE_CLIENT_SECRET"
TF_SUB_ID        = "$HE_SUB_ID"
TF_TENANT_ID     = "$HE_TENANT_ID"
EOF

```

### Run terraform

```bash

# initialize terraform
terraform init

# validate terraform config
terraform validate

```

Run terraform. Review the planned changes, and type 'yes' if the plan is what is expected.

```bash

terraform apply

```
