data "azurerm_client_config" "current" {}

resource azurerm_key_vault kv {
  name                            = "${var.NAME}-kv"
  location                        = var.LOCATION
  resource_group_name             = var.APP_RG_NAME
  sku_name                        = "standard"
  tenant_id                       = var.TENANT_ID
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore"
    ]
  }
}

resource "azurerm_key_vault_access_policy" "web_app" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id = var.TENANT_ID
  object_id = azurerm_app_service.helium-webapp.identity.0.principal_id

  secret_permissions = [
    "get",
    "list"
  ]

}

resource "azurerm_key_vault_secret" "cosmosurl" {
  name         = "CosmosUrl"
  value        = var.COSMOS_URL
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "cosmoskey" {
  name         = "CosmosKey"
  value        = var.COSMOS_KEY
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "cosmosdatabase" {
  name         = "CosmosDatabase"
  value        = var.COSMOS_DB
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "cosmoscol" {
  name         = "CosmosCollection"
  value        = var.COSMOS_COL
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "appinsights" {
  name         = "AppInsightsKey"
  value        = azurerm_application_insights.helium.instrumentation_key
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "acr_sp_secret" {
  name         = "AcrPassword"
  value        = var.ACR_SP_SECRET
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "acr_sp_id" {
  name         = "AcrUserId"
  value        = var.ACR_SP_ID
  key_vault_id = azurerm_key_vault.kv.id
}
