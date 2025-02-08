terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/contact-center/webchat/tfstate"
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
      Created     = "25 Jul 2024"
      Creator     = "Brian Gaber"
      ManagedBy   = "Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "ContactCenter"
      Portfolio   = "Digital Support"
      Incident    = "INC49523703"
    }
  }
}