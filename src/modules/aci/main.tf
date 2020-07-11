/**
* # Module Properties
*
* This module is used to create the webvalidate instances needed for End to End testing of the [Helium](https://github.com/retaildevcrews/helium) Application stack
*
* Visit the [webvalidate](https://github.com/retaildevcrews/webvalidate) project for more information on how it works
*
* Example usage and testing
*
* ```hcl
* module "aci" {
* source              = "../modules/aci"
* NAME                = var.NAME
* LOCATION            = var.LOCATION
* CONTAINER_FILE_NAME = var.CONTAINER_FILE_NAME
* ACI_RG_NAME         = azurerm_resource_group.helium-aci.name
* }
* ```
*/

resource azurerm_log_analytics_workspace helium-log {
  name                = "${var.NAME}-log"
  location            = var.LOCATION
  resource_group_name = var.ACI_RG_NAME
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_group" helium-aci {
  depends_on = [
    var.APP_SERVICE_DONE,
    azurerm_log_analytics_workspace.helium-log
  ]
  for_each            = var.WEBV_INSTANCES
  name                = "${var.NAME}-webv-${each.key}"
  # dns_name_label      = "${var.NAME}-webv-${each.key}"
  location            = each.key
  resource_group_name = var.ACI_RG_NAME
  os_type             = "Linux"

  container {
    name  = "${var.NAME}-webv-${each.key}"
    image = "retaildevcrew/webvalidate:debug"
    commands = ["dotnet", "../webvalidate.dll", "--server", "${var.NAME}", "--files", "${var.CONTAINER_FILE_NAME}", "--base-url", "https://raw.githubusercontent.com/retaildevcrews/${var.REPO}/master/TestFiles/", "--run-loop", "--sleep", "${each.value}", "--json-log", "--tag", "${each.key}"]
    cpu      = "0.5"
    memory   = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  diagnostics {
    log_analytics {
      workspace_id = azurerm_log_analytics_workspace.helium-log.workspace_id
      workspace_key = azurerm_log_analytics_workspace.helium-log.primary_shared_key
    }
  }

  tags = {
    environment = var.NAME,
    repo        = var.REPO
  }
}
