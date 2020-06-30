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
  name     = "${var.NAME}-acr-rg"
  location = var.LOCATION
}

resource "azurerm_resource_group" "cosmos" {
  name     = "${var.NAME}-cosmos-rg"
  location = var.LOCATION
}

resource "azurerm_resource_group" "helium-app" {
  name     = "${var.NAME}-app-rg"
  location = var.LOCATION
}

resource "azurerm_resource_group" "helium-aci" {
  name     = "${var.NAME}-webv-rg"
  location = var.LOCATION
}

resource "azurerm_resource_group" "tfstate" {
  name     = "${var.NAME}-tf-rg"
  location = var.LOCATION
}

resource azurerm_container_registry LOGINSERVER {
  name                = var.NAME
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.helium-acr.name
  admin_enabled       = true   
  sku                 = "Standard"
}

data "azurerm_container_registry" "LOGINSERVER" {
  name                = "loginserver"
  resource_group_name = azurerm_resource_group.helium-acr.name
}

module "acr" {
  source        = "../modules/acr"
  NAME          = var.NAME
  LOCATION      = var.LOCATION
  REPO          = var.REPO
  ACR_RG_NAME   = azurerm_resource_group.helium-acr.name
  ACR_SP_ID     = var.ACR_SP_ID
  ACR_SP_SECRET = var.ACR_SP_SECRET
  LOGINSERVER   = azurerm_container_registry.LOGINSERVER.name
}

module "db" {
  source         = "../modules/db"
  NAME           = var.NAME
  LOCATION       = var.LOCATION
  COSMOS_RG_NAME = azurerm_resource_group.cosmos.name
  COSMOS_RU      = var.COSMOS_RU
  COSMOS_DB      = var.COSMOS_DB
  COSMOS_COL     = var.COSMOS_COL
}

module "web" {
  source = "../modules/webapp"

  NAME              = var.NAME
  LOCATION          = var.LOCATION
  REPO              = var.REPO
  LOGINSERVER      = "${module.acr.LOGINSERVER}"
  ACR_SP_ID         = var.ACR_SP_ID
  ACR_SP_SECRET     = var.ACR_SP_SECRET
  APP_RG_NAME       = azurerm_resource_group.helium-app.name
  TFSTATE_RG_NAME   = azurerm_resource_group.tfstate.name
  TENANT_ID         = var.TF_TENANT_ID
  COSMOS_RG_NAME    = "${module.db.COSMOS_RG_NAME}"
  COSMOS_URL        = "https://${var.NAME}.documents.azure.com:443/"
  COSMOS_KEY        = module.db.ro_key
  COSMOS_DB         = var.COSMOS_DB
  COSMOS_COL        = var.COSMOS_COL
  IMDB_IMPORT_DONE  = "${module.db.IMDB_IMPORT_DONE}"
  TF_SUB_ID         = var.TF_SUB_ID
  ACTION_GROUP_NAME = var.ACTION_GROUP_NAME
  EMAIL_FOR_ALERTS  = var.EMAIL_FOR_ALERTS
  RT_THRESHOLD      = var.RT_THRESHOLD
  RT_OPERATOR       = var.RT_OPERATOR
  RT_SEVERITY       = var.RT_SEVERITY
  RT_FREQUENCY      = var.RT_FREQUENCY
  RT_WINDOW_SIZE    = var.RT_WINDOW_SIZE
  MR_THRESHOLD      = var.MR_THRESHOLD
  MR_OPERATOR       = var.MR_OPERATOR
  MR_SEVERITY       = var.MR_SEVERITY
  MR_FREQUENCY      = var.MR_FREQUENCY
  MR_WINDOW_SIZE    = var.MR_WINDOW_SIZE
  WT_FREQUENCY      = var.WT_FREQUENCY
  WT_WINDOW_SIZE    = var.WT_WINDOW_SIZE
  WT_SEVERITY       = var.WT_SEVERITY
  WT_THRESHOLD      = var.WT_THRESHOLD
  WT_OPERATOR       = var.WT_OPERATOR
  WV_FREQUENCY      = var.WT_FREQUENCY
  WV_WINDOW_SIZE    = var.WT_WINDOW_SIZE
  WV_SEVERITY       = var.WT_SEVERITY
  WV_THRESHOLD      = var.WT_THRESHOLD
  WV_OPERATOR       = var.WT_OPERATOR
}

module "aci" {
  source              = "../modules/aci"
  NAME                = var.NAME
  LOCATION            = var.LOCATION
  REPO                = var.REPO
  CONTAINER_FILE_NAME = var.CONTAINER_FILE_NAME
  SLEEP_TIME          = var.SLEEP_TIME
  ACI_RG_NAME         = azurerm_resource_group.helium-aci.name
  APP_SERVICE_DONE    = "${module.web.APP_SERVICE_DONE}"
}
