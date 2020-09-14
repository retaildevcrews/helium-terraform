provider "azurerm" {
  version = "~> 2.19"
  features {}

  subscription_id = var.TF_SUB_ID
  client_id       = var.TF_CLIENT_ID
  client_secret   = var.TF_CLIENT_SECRET
  tenant_id       = var.TF_TENANT_ID
}

provider "azuread" {
  version = "~> 0.11"

  subscription_id = var.TF_SUB_ID
  client_id       = var.TF_CLIENT_ID
  client_secret   = var.TF_CLIENT_SECRET
  tenant_id       = var.TF_TENANT_ID
}

locals {
  app-rg-name      = "${var.NAME}-rg-app"
  aks-cluster-name = "${var.NAME}-aks"
  aks-mi-name      = "${var.NAME}-mi"
}

resource "azurerm_resource_group" "helium-app" {
  name     = local.app-rg-name
  location = var.LOCATION
}

resource "azurerm_kubernetes_cluster" "helium-aks" {
  name                = local.aks-cluster-name
  location            = azurerm_resource_group.helium-app.location
  resource_group_name = azurerm_resource_group.helium-app.name
  dns_prefix          = local.aks-cluster-name

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }
}

resource "azurerm_user_assigned_identity" "helium-aks-mi" {
  name                = local.aks-mi-name
  location            = azurerm_resource_group.helium-app.location
  resource_group_name = azurerm_resource_group.helium-app.name
}

data "azurerm_resource_group" "helium-aks-mc-rg" {
  name = azurerm_kubernetes_cluster.helium-aks.node_resource_group
}

resource "azurerm_role_assignment" "helium-aks-mi-app-rg-reader" {
  scope                = data.azurerm_resource_group.helium-aks-mc-rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.helium-aks-mi.principal_id
}

resource "azurerm_role_assignment" "helium-aks-sp-mi-operator" {
  scope                = azurerm_user_assigned_identity.helium-aks-mi.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.helium-aks.identity.0.principal_id
}

# data "azurerm_key_vault" "helium-kv" {
#   name                = var.NAME
#   resource_group_name = local.app-rg-name
# }

# resource "azurerm_key_vault_access_policy" "web_app" {
#   key_vault_id = data.azurerm_key_vault.helium-kv.id
#   tenant_id    = var.TF_TENANT_ID
#   object_id    = azurerm_user_assigned_identity.helium-aks-mi.principal_id

#   secret_permissions = [
#     "get",
#     "list"
#   ]
# }