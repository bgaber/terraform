terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/test/careguard/event-bridge/tfstate"
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
      Created     = "18 Jun 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Careguard"
      Incident    = "INC49289333"
      Portfolio   = "Digital Support"
    }
  }
}