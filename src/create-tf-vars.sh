#!/bin/bash

# First check if the vars are set then
# create terraform.tfvars and replace template values
# replace He_Name as it may only contain alphanumeric characters and must be between 3-12 characters.  It can actually be 24 - but a lot of other variables have a 24 character limit

He_Name_Size=${#He_Name}

if [[ $He_Name_Size -gt 3 && $He_Name_Size -lt 12 ]]
then
cat ../example.tfvars | sed "s/<<He_Name>>/$He_Name/g" > terraform.tfvars
else
echo "Please set He_Name first and make sure it is between 3 and 12 characters in length with no special characters.  Visit https://github.com/RetailDevCrews/helium to get started"
fi 

# replace location 
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
