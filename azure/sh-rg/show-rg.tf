terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "example" {
  name = "rg-avs-scus-prod-001"
}

output "id" {
  value = data.azurerm_resource_group.example.id
}

output "location" {
  value = data.azurerm_resource_group.example.location
}