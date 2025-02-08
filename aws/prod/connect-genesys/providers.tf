terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/prod/connect-genesys/tfstate"
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
      Created     = "08 Aug 2024"
      Creator     = "Brian Gaber"
      ManagedBy   = "Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Connect"
      Portfolio   = "Digital Support"
      Incident    = "INC49599346"
    }
  }
}

provider "aws" {
  alias   = "route53"
  region  = var.region
  profile = var.route53_cred_profile

  default_tags {
    tags = {
      Created     = "08 Aug 2024"
      Creator     = "Brian Gaber"
      ManagedBy   = "Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Connect"
      Portfolio   = "Digital Support"
      Incident    = "INC49599346"
    }
  }
}