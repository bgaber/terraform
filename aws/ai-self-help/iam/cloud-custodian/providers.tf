terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/ai-self-help/iam/cloud-custodian/tfstate"
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
      Created     = "03 Sep 2024"
      Creator     = "Brian Gaber"
      ManagedBy   = "Terraform"
      Owner       = "Brian Gaber"
      Application = "SRETools"
      Portfolio   = "Other"
    }
  }
}