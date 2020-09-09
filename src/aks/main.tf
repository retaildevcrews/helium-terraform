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
  aks-cluster-name = "${var.NAME}-aks"
  aks-mi-name      = "${var.NAME}-mi"
}

resource "azurerm_resource_group" "helium-app" {
  name     = "${var.NAME}-rg-app"
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

resource "azurerm_user_assigned_identity" "helium-aks-identity" {
  name                = local.aks-mi-name
  location            = azurerm_resource_group.helium-app.location
  resource_group_name = azurerm_resource_group.helium-app.name
}
