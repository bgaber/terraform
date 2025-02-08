terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/shared/delinea/security-group/tfstate"
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
      Created     = "07 Sep 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Diane Chrisstoffels"
      Incident    = "INC46270577"
    }
  }
}