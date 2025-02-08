terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/shared/iam/INC48640355/tfstate"
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
      Created     = "21 Mar 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Marisol Granados"
      Application = "Data Engineering"
      Portfolio   = "AiOps"
      Incident    = "INC48640355"
    }
  }
}

provider "aws" {
  alias   = "dev_alias"
  region  = var.region
  profile = var.dev_switch_role_cred_profile

  default_tags {
    tags = {
      Created     = "21 Mar 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Marisol Granados"
      Application = "Data Engineering"
      Portfolio   = "AiOps"
      Incident    = "INC48640355"
    }
  }
}
