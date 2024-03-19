terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/ai-self-help/experience-mgt/kinesis/tfstate"
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
      Created     = "06 Dec 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Trevor Kirk"
      Application = "Experience Management"
      Incident    = "INC47821968"
    }
  }
}