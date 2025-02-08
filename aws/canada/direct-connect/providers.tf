terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/canada/direct-connect/tfstate"
    region  = "us-east-1"
    profile = "Shared"
    dynamodb_table = "terraform-backend"
  }
}

# Local account creates the ca-central-1 transit gateway and accepts the VPC attachment.
provider "aws" {
  region  = var.local_region
  profile = var.canada_cred_profile
  default_tags {
    tags = {
      Created     = "02 Apr 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Jason Boomer"
      Application = "SRETools"
      Change      = "CHG212563"
    }
  }
}