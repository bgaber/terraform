terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/test/iam/INC48852654/tfstate"
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
      Created     = "08 Apr 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Dennis Jones"
      Application = "Control-M"
      Incident    = "INC48852654"
      Purpose     = "Service Account for Control-M"
    }
  }
}