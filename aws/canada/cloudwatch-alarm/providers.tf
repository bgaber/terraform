terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/canada/cloudwatch-alarm/tfstate"
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
      Created     = "05 Mar 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Bill Canupp"
      Name        = "bonitasoft-rds-low-free-disk-space"
    }
  }
}