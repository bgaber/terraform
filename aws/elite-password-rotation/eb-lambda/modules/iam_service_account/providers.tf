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
}

provider "aws" {
  region  = var.region
  default_tags {
    tags = {
      Created   = "26 Feb 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "NOC-1239"
      Purpose   = "Elite User Password Rotation"
    }
  }
}

# ensure the GITLAB_TOKEN environment variable has been set:
# export GITLAB_TOKEN="your-personal-access-token"
provider "gitlab" {
  base_url  = "https://gitlab.tecsysrd.cloud/api/v4/"
}