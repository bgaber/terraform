terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  cloud {
    organization = "Compucom"

    workspaces {
      name = "server-test"
    }
  }
}

provider "aws" {
  region  = var.region
  default_tags {
    tags = {
      Created     = "13 Feb 2024"
      Creator     = "Brian Gaber using TFC"
      Owner       = "Brian Gaber"
    }
  }
}