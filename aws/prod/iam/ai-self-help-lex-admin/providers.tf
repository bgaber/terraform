terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/prod/iam/ai-self-help-lex-admin/tfstate"
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
      Created     = "31 Jul 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rex Hiltz"
      Application = "AI SelfHelp"
      Incident    = "INC46770063"
    }
  }
}

provider "aws" {
  alias   = "switch_role"
  region  = var.region
  profile = var.switch_role_cred_profile

  default_tags {
    tags = {
      Created     = "31 Jul 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rex Hiltz"
      Application = "AI SelfHelp"
      Incident    = "INC46770063"
    }
  }
}