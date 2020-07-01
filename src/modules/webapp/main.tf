/**
* # Module Properties
*
* This module is used to create the AppService, WebApp for Containers(linux), Azure Key Vault and the AppInsights used by the [Helium](https://github.com/retaildevcrews/helium) application.
*
* This module is broken into 4 separate files for ease of organization but are treated as 1 single flat Terraform template when called by the module.
* This module also securely stores the tfstate files in an encrypted Azure blob
*
** Four alerts for  AppInsights are also provided as part of the service.  They are:
*  Web Test (WT) Availability (Service up / down)
*  Response Time (RT) (over 300 milliseconds)
*  Maximum requests (MR) (over 600)
*  Webv requests below 1 (WV) (less than 1)
*
* Additional Parameters to Customize Alerts are available to you outside of Helium.
*
* (See complete list [here](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/app-insights-metrics))

* requests/count (Total Server Requests)
* requests/failed (Total Failed Server Requests)
* requests/duration (Server Response Time)
* performanceCounters/processCpuPercentage (% total CPU used by process)

* Window Sizes (aggregation granularities)

* 1m
* 5m
* 15m
* 30m
* 1h
* 6h
* 12h
* 24h

### Evaluation Frequencies

Note: The evaluation frequency must be less than or equal to the window size.

* 1m
* 5m
* 15m
* 30m
* 1h
*
* Example usage and testing
*
* ```hcl
* module "web" {
* source = "../modules/webapp"
*
* NAME        = var.NAME
* LOCATION    = var.LOCATION
* APP_RG_NAME = azurerm_resource_group.helium-app.name
* TENANT_ID   = var.TF_TENANT_ID
* COSMOS_URL  = "https://${module.db.cosmos_name}.documents.azure.com:443/"
* COSMOS_KEY  = module.db.ro_key
* COSMOS_DB   = "imdb"
* COSMOS_COL  = "movies"
* }
* ```
*/

resource azurerm_app_service_plan helium-app-plan {
  name                = "${var.NAME}-plan"
  location            = var.LOCATION
  resource_group_name = var.APP_RG_NAME
  kind                = "linux"
  reserved            = true
  sku {
    tier = "Basic"
    size = "B2"
  }
}

resource azurerm_app_service helium-webapp {
  depends_on = [
    var.IMDB_IMPORT_DONE
  ]
  name                = var.NAME
  location            = var.LOCATION
  resource_group_name = var.APP_RG_NAME
  https_only          = false
  app_service_plan_id = azurerm_app_service_plan.helium-app-plan.id

  site_config {
    always_on                 = "true"
    app_command_line          = ""
    linux_fx_version          = "DOCKER|${var.NAME}.azurecr.io/${var.REPO}:latest"
    use_32_bit_worker_process = "true"
  }
  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://${var.NAME}.azurecr.io"
    "DOCKER_ENABLE_CI"                    = "true"
    "KEYVAULT_NAME"                       = "${var.NAME}-kv"
  }
}

output "APP_SERVICE_DONE" {
  depends_on  = [azurerm_app_service.helium-webapp]
  value       = true
  description = "App Service setup is complete"
}
