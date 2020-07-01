/**
* # Module Properties
*
* This module is used to create the CosmosDB instance, Databases and collections for the [Helium](https://github.com/retaildevcrews/helium) application
*
* For this to work the system running the TF `apply` will need to have the docker runtime installed and working.
*
* Example usage and Testing
*
* ```hcl
* module "db" {
* source         = "../modules/db"
* COSMOS_RG_NAME = azurerm_resource_group.cosmos.name
* NAME           = var.NAME
* LOCATION       = var.LOCATION
* COSMOS_RU      = var.COSMOS_RU
* }
* ```
*/

resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = var.NAME
  location            = var.LOCATION
  resource_group_name = var.COSMOS_RG_NAME
  kind                = "GlobalDocumentDB"
  offer_type          = "Standard"
  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = "5"
    max_staleness_prefix    = "100"
  }
  enable_automatic_failover = false
  geo_location {
    location          = var.LOCATION
    failover_priority = "0"
  }
}

output "ro_key" {
  value       = azurerm_cosmosdb_account.cosmosdb.primary_readonly_master_key
  sensitive   = true
  description = "The read Only key for the CosmosDB to be used by the Helium Application. This is used to pass into the webapp module"
}


output "cosmos_name" {
  value       = azurerm_cosmosdb_account.cosmosdb.name
  description = "The name of the CosmosDb instance"
}

output "COSMOS_RG_NAME" {
  value       = azurerm_cosmosdb_account.cosmosdb.resource_group_name
  description = "The name of the CosmosDb resource group"
}

resource "azurerm_cosmosdb_sql_database" "cosmosdb-imdb" {
  name                = var.COSMOS_DB
  resource_group_name = var.COSMOS_RG_NAME
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  throughput          = var.COSMOS_RU
}

resource "azurerm_cosmosdb_sql_container" "cosmosdb-movies" {
  name                = var.COSMOS_COL
  resource_group_name = var.COSMOS_RG_NAME
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.cosmosdb-imdb.name
  partition_key_path  = "/partitionKey"
}

resource null_resource imdb-import {
  provisioner "local-exec" {
    // me command = "docker pull \"${var.acr}\":latest && docker run --log-opt mode=non-blocking --log-opt max-buffer-size=4m --rm --name imdb-import \"${var.acr}/${var.REPO}\":latest \"${azurerm_cosmosdb_account.cosmosdb.name}\" \"${azurerm_cosmosdb_account.cosmosdb.primary_master_key}\" \"${azurerm_cosmosdb_sql_database.cosmosdb-imdb.name}\" \"${azurerm_cosmosdb_sql_container.cosmosdb-movies.name}\""
    command = "docker pull retaildevcrew/imdb-import:latest && docker run --rm --name imdb-import retaildevcrew/imdb-import:latest \"${azurerm_cosmosdb_account.cosmosdb.name}\" \"${azurerm_cosmosdb_account.cosmosdb.primary_master_key}\" \"${azurerm_cosmosdb_sql_database.cosmosdb-imdb.name}\" \"${azurerm_cosmosdb_sql_container.cosmosdb-movies.name}\""
    //  command = "docker pull \"${var.acr}\":latest && docker run --log-opt mode=non-blocking --log-opt max-buffer-size=4m --rm --name imdb-import \"${var.acr}/${var.REPO}\":latest \"${azurerm_cosmosdb_account.cosmosdb.name}\"\"${azurerm_cosmosdb_account.cosmosdb.primary_master_key}\"\"${azurerm_cosmosdb_sql_database.cosmosdb-imdb.name}\"\"${azurerm_cosmosdb_sql_container.cosmosdb-movies.name}\""
  }
}

output "IMDB_IMPORT_DONE" {
  depends_on  = [null_resource.imdb-import]
  value       = true
  description = "imdb-import complete"
}
