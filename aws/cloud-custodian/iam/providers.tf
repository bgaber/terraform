terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    gitlab = {
      source = "gitlabhq/gitlab"
      version = ">= 17.8.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-tecsys"
    key     = "aws/cloud-custodian/iam/tfstate"
    region  = "us-east-1"
    #dynamodb_table = "terraform-backend"
  }
}

provider "aws" {
  region  = var.region
  default_tags {
    tags = {
      Created       = "07 Feb 2025"
      Creator       = "Brian Gaber"
      ManagedBy     = "Terraform"
      Owner         = "Colin Krane"
      Application   = "Cloud Custodian"
    }
  }
}

# ensure the following GITLAB_TOKEN environment variable has been set:
# export GITLAB_TOKEN="your-personal-access-token"
provider "gitlab" {
  base_url  = "https://gitlab.tecsysrd.cloud/api/v4/"
}