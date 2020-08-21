terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    docker = {
      source = "terraform-providers/docker"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 0.13"
}
