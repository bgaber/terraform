terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/prod/travel.compucom.com/tfstate"
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
      Created     = "21 Sep 2024"
      Creator     = "Brian Gaber"
      ManagedBy   = "Terraform"
      Owner       = "Rajesh Sermadurai"
      Incident    = "INC49874842"
      Portfolio   = "Digital Support"
    }
  }
}

provider "aws" {
  alias   = "route53"
  region  = var.region
  profile = var.route53_cred_profile

  default_tags {
    tags = {
      Created     = "21 Sep 2024"
      Creator     = "Brian Gaber"
      ManagedBy   = "Terraform"
      Owner       = "Rajesh Sermadurai"
      Incident    = "INC49874842"
      Portfolio   = "Digital Support"
    }
  }
}