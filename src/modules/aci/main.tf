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
* SLEEP_TIME          = var.SLEEP_TIME
* ACI_RG_NAME         = azurerm_resource_group.helium-aci.name
* }
* ```
*/

resource "azurerm_application_insights" "appIns" {
  name                = "${var.NAME}-webv"
  location            = var.LOCATION
  resource_group_name = var.ACI_RG_NAME
  application_type    = "web"
}

output "instrumentation_key" {
  value       = azurerm_application_insights.appIns.instrumentation_key
  description = "Instrumentation Key for the webvalidate instance to be used by a dashboard module if you want a dashboard to monitor webv metrics"
}

resource "azurerm_container_group" helium-aci {
  depends_on = [
    var.APP_SERVICE_DONE
  ]
  name                = var.NAME
  location            = var.LOCATION
  resource_group_name = var.ACI_RG_NAME
  dns_name_label      = "${var.NAME}-aci"
  os_type             = "Linux"
  container {
    name     = "${var.NAME}-webv"
    image    = "retaildevcrew/webvalidate"
    commands = ["dotnet", "../webvalidate.dll", "--server", "${var.NAME}", "--files", "${var.CONTAINER_FILE_NAME}", "--base-url", "https://raw.githubusercontent.com/retaildevcrews/${var.REPO}/master/TestFiles/", "--run-loop", "--sleep", "${var.SLEEP_TIME}", "--telemetry-name", "${var.NAME}", "--telemetry-key", azurerm_application_insights.appIns.instrumentation_key]
    cpu      = "0.5"
    memory   = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
  tags = {
    environment = var.NAME,
    repo        = var.REPO
  }
}
