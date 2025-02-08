terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/shared/iam/canada-network/tfstate"
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
      Created     = "23 Oct 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Davood Zarei"
      Application = "Canada Network"
      Incident    = "INC47465428"
    }
  }
}

provider "aws" {
  alias   = "switch_role"
  region  = var.region
  profile = var.switch_role_cred_profile

  default_tags {
    tags = {
      Created     = "23 Oct 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Davood Zarei"
      Application = "Canada Network"
      Incident    = "INC47465428"
    }
  }
}