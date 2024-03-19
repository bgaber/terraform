# The purpose of this Terraform code is to give certain users developer access in the Shared and AI-SelfHelp accounts for the Service Desk DR project

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/shared/iam/service-desk-dr/tfstate"
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
      Created     = "26 Sep 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Service-Desk-DR"
      Incident    = "INC47269652"
    }
  }
}

provider "aws" {
  alias   = "aish_switch_role"
  region  = var.region
  profile = var.aish_switch_role_cred_profile

  default_tags {
    tags = {
      Created     = "26 Sep 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Service-Desk-DR"
      Incident    = "INC47269652"
    }
  }
}

provider "aws" {
  alias   = "prod_switch_role"
  region  = var.region
  profile = var.prod_switch_role_cred_profile

  default_tags {
    tags = {
      Created     = "26 Sep 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Service-Desk-DR"
      Incident    = "INC47269652"
    }
  }
}