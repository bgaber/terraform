terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/ai-self-help/elastic/tfstate"
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
      Created     = "24 Jul 2024"
      Creator     = "Brian Gaber"
      ManagedBy   = "Terraform"
      Owner       = "Amar Singh"
      Application = "DigitalAssistant"
      Portfolio   = "Digital Support"
      Incident    = "INC49482401"
    }
  }
}