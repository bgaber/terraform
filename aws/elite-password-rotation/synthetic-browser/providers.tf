terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-tecsys"
    key     = "aws/elite-password-rotation-parameter-store/tfstate"
    region  = "us-east-1"
    #dynamodb_table = "terraform-backend"
  }
}

provider "aws" {
  region  = var.region
  default_tags {
    tags = {
      Created   = "22 Apr 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "NOC-1239"
      Purpose   = "Elite User Password Rotation"
    }
  }
}