terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      version = "~>1.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
    docker = {
      source = "terraform-providers/docker"
      version = "~>2.7"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}