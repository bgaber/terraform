terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/test/elastic/tfstate"
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
      Created     = "21 Aug 2024"
      Creator     = "Brian Gaber"
      ManagedBy   = "Terraform"
      Owner       = "Amar Singh"
      Application = "DigitalAssistant"
      Portfolio   = "Digital Support"
      Incident    = "INC49482401"
    }
  }
}