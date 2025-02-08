terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-tecsys"
    key     = "aws/elite-password-rotation/tfstate"
    region  = "us-east-1"
    #dynamodb_table = "terraform-backend"
  }
}

provider "aws" {
  region  = var.region
  default_tags {
    tags = {
      Created   = "02 Dec 2024"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Lucas Cardim"
      JIRA      = "NOC-976"
      Purpose   = "Elite User Password Rotation"
    }
  }
}