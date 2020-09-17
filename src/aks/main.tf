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
  app-mi-name      = "${var.NAME}-mi"
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

data "azurerm_resource_group" "helium-aks-node-rg" {
  name = azurerm_kubernetes_cluster.helium-aks.node_resource_group
}

resource "azurerm_user_assigned_identity" "helium-podidentity-mi" {
  name                = local.app-mi-name
  location            = azurerm_resource_group.helium-app.location
  resource_group_name = data.azurerm_resource_group.helium-aks-node-rg.name
}

resource "azurerm_role_assignment" "helium-podidentity-mi-aksnoderg-reader" {
  scope                = data.azurerm_resource_group.helium-aks-node-rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.helium-podidentity-mi.principal_id
}

resource "azurerm_role_assignment" "helium-aks-mi-aksnoderg-mioperator" {
  scope                = data.azurerm_resource_group.helium-aks-node-rg.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.helium-aks.kubelet_identity.0.object_id
}

resource "azurerm_role_assignment" "helium-aks-mi-aksnoderg-vmcontrib" {
  scope                = data.azurerm_resource_group.helium-aks-node-rg.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_kubernetes_cluster.helium-aks.kubelet_identity.0.object_id
}
