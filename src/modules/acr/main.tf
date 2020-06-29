/**
* # Module Properties
*
* This module is used to create the azure container registry to store private copies of the [Helium](https://github.com/retaildevcrews/helium) application containers or a private copy of the [webvalidate](https://github.com/retaildevcrews/webvalidate) container to use in this test environment
* 
* For this to work you will need to assign `AcrPull` rights to the Application Insights service to the ACR post deployment. 
*
* Example usage
*
* ```hcl
* module "acr" {
* source      = "../modules/acr"
* NAME        = var.NAME
* LOCATION    = var.LOCATION
* ACR_RG_NAME = azurerm_resource_group.helium-acr.name
* }
* ```
*/

resource azurerm_container_registry helium-acr {
  name                = var.NAME
  location            = var.LOCATION
  resource_group_name = var.ACR_RG_NAME
  admin_enabled       = false
  sku                 = "Standard"
}

output "acr" {
  value       = azurerm_container_registry.helium-acr.name
  description = "The name of the Azure Container Registry"
}

resource null_resource acr-access {
  provisioner "local-exec" {
    command = "az role assignment create --scope ${azurerm_container_registry.helium-acr.id} --role acrpull --assignee ${var.ACR_SP_ID}"
  }
}

resource null_resource acr-import {
  provisioner "local-exec" {
    command = "az acr import -n ${azurerm_container_registry.helium-acr.name} --source docker.io/retaildevcrew/helium-${var.LANGUAGE}:stable --image helium-${var.LANGUAGE}:latest --username ${var.ACR_SP_ID} --password ${var.ACR_SP_SECRET}"
  }
}
resource "azurerm_container_registry_webhook" "webhook" {
  name                = var.NAME
  location            = var.LOCATION
  resource_group_name = var.ACR_RG_NAME
  registry_name       = azurerm_container_registry.helium-acr.name

  service_uri = "https://${var.NAME}.scm.azurewebsites.net/docker/hook"
  status      = "enabled"
  scope       = "helium-${var.NAME}:latest"
  actions     = ["push"]
  custom_headers = {
    "Content-Type" = "application/json"
  }
}
