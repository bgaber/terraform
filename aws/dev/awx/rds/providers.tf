terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/dev/awx/rds/tfstate"
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
      Created     = "09 Apr 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Brian Gaber"
      Application = "SRETools"
      Purpose     = "AWX Testing"
    }
  }
}