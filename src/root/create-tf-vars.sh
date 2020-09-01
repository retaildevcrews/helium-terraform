#!/bin/bash

# check if He_Name is valid

Name_Size=${#He_Name}
if [[ $Name_Size -lt 3 || $Name_Size -gt 12 ]]
then
  echo "Please set He_Name first and make sure it is between 3 and 12 characters in length with no special characters."
  exit 1
fi

Email_Size=${#He_Email}
if [[ $Email_Size -lt 6 ]]
then
  echo "Please export He_Email first and make sure it is a valid email."
  exit 1
fi

# set location to centralus if not set
if [ -z $He_Location ]
then
  export He_Location=centralus
fi

# set repo to helium-csharp if not set
if [ -z $He_Repo ]
then
  export He_Repo=helium-csharp
fi

# create terraform.tfvars

cat << EOF > ./terraform.tfvars

NAME             = "$He_Name"
LOCATION         = "$He_Location"
REPO             = "$He_Repo"
EMAIL_FOR_ALERTS = "$He_Email"
TF_TENANT_ID     = "$(az account show -o tsv --query tenantId)"
TF_SUB_ID        = "$(az account show -o tsv --query id)"
TF_CLIENT_SECRET = "$(az ad sp create-for-rbac -n http://${He_Name}-tf-sp --query password -o tsv)"
TF_CLIENT_ID     = "$(az ad sp show --id http://${He_Name}-tf-sp --query appId -o tsv)"
ACR_SP_SECRET    = "$(az ad sp create-for-rbac --skip-assignment -n http://${He_Name}-acr-sp --query password -o tsv)"
ACR_SP_ID        = "$(az ad sp show --id http://${He_Name}-acr-sp --query appId -o tsv)"


WEBV_INSTANCES = {
  "<<He_Location>>" = 1000
  "eastus2"         = 5000
  "westeurope"      = 15000
  "southeastasia"   = 30000
}
CONTAINER_FILE_NAME = "benchmark.json"
COSMOS_RU           = "1000"

ALERT_RULES = {
  rt_alerts = {
    name        = "response-time-alert"
    frequency   = "PT15M"
    window_size = "PT30M"
    description = "Server Response Time Too High"
    severity    = 2
    enabled     = false
    operator    = "GreaterThan"
    threshold   = "900"
    aggregation = "Average"
    metric_name = "requests/duration"
  },
  mr_alerts = {
    name        = "requests-too-high-alert"
    frequency   = "PT1M"
    window_size = "PT15M"
    description = "Requests Too High"
    severity    = 2
    enabled     = false
    operator    = "GreaterThan"
    threshold   = "900"
    aggregation = "Count"
    metric_name = "requests/count"
  },
  wv_alerts = {
    name        = "requests-too-low-alert"
    frequency   = "PT1M"
    window_size = "PT5M"
    description = "Requests Too Low"
    severity    = 2
    enabled     = true
    operator    = "LessThan"
    threshold   = "1"
    aggregation = "Count"
    metric_name = "requests/count"
  }
}
WEBTEST_ALERT_RULES = {
  wt_rules = {
    name        = "web-test-alert"
    frequency   = "PT5M"
    window_size = "PT15M"
    description = "Web Test Alert"
    severity    = 2
    enabled     = false
    operator    = "LessThan"
    threshold   = "1"
    aggregation = "Average"
    metric_name = "availabilityResults/availabilityPercentage"
  }
}

EOF

# validate the substitutions
cat terraform.tfvars


# create tf_state resource group
export TFSTATE_RG_NAME=$He_Name-rg-tf
echo "Creating the TFState Resource Group"
if echo ${TFSTATE_RG_NAME} > /dev/null 2>&1 && echo ${He_Location} > /dev/null 2>&1; then
    if ! az group create --name ${TFSTATE_RG_NAME} --location ${He_Location} -o table; then
        echo "ERROR: failed to create the resource group"
        exit 1
    fi
    echo "Created Resource Group: ${TFSTATE_RG_NAME} in ${TF_LOCATION}"
fi

# create storage account for state file
export TFSUB_ID=$(az account show -o tsv --query id)
export TFSA_NAME=tfstate$RANDOM
echo "Creating State File Storage Account and Container"
if echo ${TFSUB_ID} > /dev/null 2>&1; then
    if ! az storage account create --resource-group $TFSTATE_RG_NAME --name $TFSA_NAME --sku Standard_LRS --encryption-services blob -o table; then
        echo "ERROR: Failed to create Storage Account"
        exit 1
    fi
    echo "TF State Storage Account Created. Name = $TFSA_NAME"
    sleep 20s
fi

# retrieve storage account access key
if echo ${TFSTATE_RG_NAME} > /dev/null 2>&1; then
    if ! ARM_ACCESS_KEY=$(az storage account keys list --resource-group $TFSTATE_RG_NAME --account-name $TFSA_NAME --query [0].value -o tsv); then
        echo "ERROR: Failed to Retrieve Storage Account Access Key"
        exit 1
    fi
    echo "TF State Storage Account Access Key = $ARM_ACCESS_KEY"
fi

if echo ${TFSTATE_RG_NAME} > /dev/null 2>&1; then
    if ! az storage container create --name "container${TFSA_NAME}" --account-name $TFSA_NAME --account-key $ARM_ACCESS_KEY -o table; then
        echo "ERROR: Failed to Retrieve Storage Container"
        exit 1
    fi
    echo "TF State Storage Account Container Created"
    export TFSA_CONTAINER=$(az storage container show --name "container${TFSA_NAME}" --account-name ${TFSA_NAME} --account-key ${ARM_ACCESS_KEY} --query name -o tsv)
    echo "TF Storage Container name = ${TFSA_CONTAINER}"
fi

# create storage container 

echo "The terraform options to store state remotely will be added as main_tf_state.tf in your root directory"
cat << EOF > ./main_tf_state.tf

terraform {
  required_version = ">= 0.13"
  backend "azurerm" {
    resource_group_name  = "${TFSTATE_RG_NAME}"
    storage_account_name = "${TFSA_NAME}"
    container_name       = "${TFSA_CONTAINER}"
    key                  = "prod.terraform.tfstate"
  }
}

EOF
