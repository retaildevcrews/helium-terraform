/**
* # Parent Template Properties
*
* This is the parent Terraform Template used to call the component modules to create the infrastructure and deploy the [Helium](https://github.com/retaildevcrews/helium) application.
*
* The only resurces created in the template are the resource groups that each Service will go into. It is advised to create a terraform.tfvars file to assign values to the variables in the `variables.tf` file.
*
* To keep sensitive keys from being stored on disk or source control you can set local environment variables that start with TF_VAR_**NameOfVariable**. This can be used with the Terraform Service Principal Variables
*
* tfstate usage (not real values)
*
* ```shell
* export TF_VAR_TF_SUB_ID="gy6tgh5t-9876-3uud-87y3-r5ygytd6uuyr"
* export TF_VAR_TF_TENANT_ID="frf34ft5-gtfv-wr34-343fw-hfgtry657uk8"
* export TF_VAR_TF_CLIENT_ID="ju76y5h8-98uh-oin8-n7ui-ger43k87d5nl"
* export TF_VAR_TF_CLIENT_SECRET="kjbh89098hhiuovvdh6j8uiop="
* ```
*/

provider "azurerm" {
  version = "2.0.0"
  features {}

  subscription_id = var.TF_SUB_ID
  client_id       = var.TF_CLIENT_ID
  client_secret   = var.TF_CLIENT_SECRET
  tenant_id       = var.TF_TENANT_ID
}

provider "azuread" {
  subscription_id = var.TF_SUB_ID
  client_id       = var.TF_CLIENT_ID
  client_secret   = var.TF_CLIENT_SECRET
  tenant_id       = var.TF_TENANT_ID
}

resource "azurerm_resource_group" "helium-acr" {
  name     = "${var.NAME}-rg-acr"
  location = var.LOCATION
}

resource "azurerm_resource_group" "cosmos" {
  name     = "${var.NAME}-rg-cosmos"
  location = var.LOCATION
}

resource "azurerm_resource_group" "helium-app" {
  name     = "${var.NAME}-rg-app"
  location = var.LOCATION
}

resource "azurerm_resource_group" "helium-aci" {
  name     = "${var.NAME}-rg-webv"
  location = var.LOCATION
}

module "acr" {
  source        = "../modules/acr"
  NAME          = var.NAME
  LOCATION      = var.LOCATION
  REPO          = var.REPO
  ACR_RG_NAME   = azurerm_resource_group.helium-acr.name
  ACR_SP_ID     = var.ACR_SP_ID
  ACR_SP_SECRET = var.ACR_SP_SECRET
}

module "db" {
  source         = "../modules/db"
  NAME           = var.NAME
  LOCATION       = var.LOCATION
  COSMOS_RG_NAME = azurerm_resource_group.cosmos.name
  COSMOS_RU      = var.COSMOS_RU
  COSMOS_DB      = var.COSMOS_DB
  COSMOS_COL     = var.COSMOS_COL
  ACR_SP_ID      = var.ACR_SP_ID
  ACR_SP_SECRET  = var.ACR_SP_SECRET
}

module "web" {
  source = "../modules/webapp"

  NAME                = var.NAME
  LOCATION            = var.LOCATION
  REPO                = var.REPO
  ACR_SP_ID           = var.ACR_SP_ID
  ACR_SP_SECRET       = var.ACR_SP_SECRET
  APP_RG_NAME         = azurerm_resource_group.helium-app.name
  TFSTATE_RG_NAME     = "${var.NAME}-rg-tf" 
  TENANT_ID           = var.TF_TENANT_ID
  COSMOS_RG_NAME      = azurerm_resource_group.cosmos.name
  COSMOS_URL          = "https://${var.NAME}.documents.azure.com:443/"
  COSMOS_KEY          = module.db.ro_key
  COSMOS_DB           = var.COSMOS_DB
  COSMOS_COL          = var.COSMOS_COL
  IMDB_IMPORT_DONE    = "${module.db.IMDB_IMPORT_DONE}"
  APP_SERVICE_DONE    = "${module.web.APP_SERVICE_DONE}"
  ACI_DONE            = "${module.aci.ACI_DONE}"
  TF_SUB_ID           = var.TF_SUB_ID
  EMAIL_FOR_ALERTS    = var.EMAIL_FOR_ALERTS
  ALERT_RULES         = var.ALERT_RULES
  WEBTEST_ALERT_RULES = var.WEBTEST_ALERT_RULES
}

module "aci" {
  source              = "../modules/aci"
  NAME                = var.NAME
  LOCATION            = var.LOCATION
  WEBV_INSTANCES      = var.WEBV_INSTANCES
  REPO                = var.REPO
  CONTAINER_FILE_NAME = var.CONTAINER_FILE_NAME
  ACI_RG_NAME         = azurerm_resource_group.helium-aci.name
  APP_SERVICE_DONE    = "${module.web.APP_SERVICE_DONE}"
}
