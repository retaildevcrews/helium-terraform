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

resource "azurerm_resource_group" "helium-app" {
  name     = "${var.NAME}-rg-app"
  location = var.LOCATION
}

resource "azurerm_kubernetes_cluster" "helium-aks" {
  name                = var.NAME
  location            = azurerm_resource_group.helium-app.location
  resource_group_name = azurerm_resource_group.helium-app.name
  dns_prefix          = var.NAME

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
