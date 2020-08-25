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

# create terraform.tfvars and replace template values

cat ../example.tfvars | \
# replace name
  sed "s/<<He_Name>>|$He_Name/g" | \

# replace location
  sed "s/<<He_Location>>/$He_Location/g" | \

# replace repo
  sed "s/<<He_Repo>>/$He_Repo/g" | \

# replace email
  sed "s/<<He_Email>>/$He_Email/g" | \

# replace TF_TENANT_ID
  sed "s/<<HE_TENANT_ID>>/$(az account show -o tsv --query tenantId)/g" | \

# replace TF_SUB_ID
  sed "s/<<HE_SUB_ID>>/$(az account show -o tsv --query id)/g" | \

# create a service principal
# replace TF_CLIENT_SECRET
  sed "s/<<HE_CLIENT_SECRET>>/$(az ad sp create-for-rbac -n http://${He_Name}-tf-sp --query password -o tsv)/g" | \

# replace TF_CLIENT_ID
  sed "s/<<HE_CLIENT_ID>>/$(az ad sp show --id http://${He_Name}-tf-sp --query appId -o tsv)/g" | \

# create a service principal
# replace ACR_SP_SECRET
  sed "s/<<HE_ACR_SP_SECRET>>/$(az ad sp create-for-rbac --skip-assignment -n http://${He_Name}-acr-sp --query password -o tsv)/g" | \

# replace ACR_SP_ID
  sed "s/<<HE_ACR_SP_ID>>/$(az ad sp show --id http://${He_Name}-acr-sp --query appId -o tsv)/g" > terraform.tfvars

# validate the substitutions
cat terraform.tfvars
