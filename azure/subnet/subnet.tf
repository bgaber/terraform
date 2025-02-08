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
  subscription_id = "90071255-2ee6-4eb7-aad6-b984394f67e5"
  features {}
}

data "azurerm_subnet" "private_b" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group
}

output "subnet_id" {
  value = data.azurerm_subnet.private_b.id
}