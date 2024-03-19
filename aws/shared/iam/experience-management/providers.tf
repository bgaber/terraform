terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/shared/iam/experience-management/tfstate"
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
      Created     = "14 Nov 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Trevor Kirk"
      Application = "Experience Management"
      Incident    = "INC47699423"
    }
  }
}

provider "aws" {
  alias   = "switch_role"
  region  = var.region
  profile = var.switch_role_cred_profile

  default_tags {
    tags = {
      Created     = "14 Nov 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Trevor Kirk"
      Application = "Experience Management"
      Incident    = "INC47699423"
    }
  }
}