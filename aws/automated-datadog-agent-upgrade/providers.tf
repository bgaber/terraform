terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-tecsys"
    key     = "aws/automated-agent-installation/tfstate"
    region  = "us-east-1"
    #dynamodb_table = "terraform-backend"
  }
}

provider "aws" {
  region  = var.region
  default_tags {
    tags = {
      Created   = "11 Mar 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "NOC-1486"
      Purpose   = "Automated Agent Installation"
    }
  }
}