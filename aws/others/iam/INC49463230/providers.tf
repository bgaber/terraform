terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/other/iam/INC49463230/tfstate"
    region  = "us-east-1"
    profile = "Shared"
    dynamodb_table = "terraform-backend"
  }
}

provider "aws" {
  region  = var.region
  profile = join("-", ["US", title(terraform.workspace)])
  default_tags {
    tags = {
      Created     = "17 Jul 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Luis Fuentes"
      Application = "Experience Management"
      Portfolio   = "Digital Support"
      Incident    = "INC49463230"
    }
  }
}
