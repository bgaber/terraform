terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/shared/iam/bb-user-for-terraform-ci/tfstate"
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
      Created     = "25 Oct 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Brian Gaber"
      Application = "SRETools"
      Purpose     = "Service Account for Bitbucket"
    }
  }
}

provider "aws" {
  alias   = "switch_role"
  region  = var.region
  profile = var.switch_role_cred_profile

  default_tags {
    tags = {
      Created     = "25 Oct 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Brian Gaber"
      Application = "SRETools"
      Purpose     = "Service Account for Bitbucket"
    }
  }
}