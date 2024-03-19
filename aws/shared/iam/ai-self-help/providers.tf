terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.login_cred_profile
  default_tags {
    tags = {
      Created     = "25 May 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rex Hiltz"
      Application = "AI Self Help"
      Incident    = "INC45985229"
    }
  }
}

provider "aws" {
  alias   = "switch_role"
  region  = var.region
  profile = var.switch_role_cred_profile

  default_tags {
    tags = {
      Created     = "25 May 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rex Hiltz"
      Application = "AI Self Help"
      Incident    = "INC45985229"
    }
  }
}