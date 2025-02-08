terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.1"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "azure/servers/windows/tfstate"
    region  = "us-east-1"
    profile = "Shared"
    dynamodb_table = "terraform-backend"
  }
}

provider "aws" {
  region  = var.region
  profile = var.login_cred_profile
  default_tags {
    tags = {
      Created     = "27 Jun 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Matthew Riding"
      Application = "AIOps"
      Change      = "CHG215101"
      Portfolio   = "AIOps"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "90071255-2ee6-4eb7-aad6-b984394f67e5"
  features {}
}