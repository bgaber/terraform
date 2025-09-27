terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-tecsys"
    key     = "aws/cloud-custodian/iam/tfstate"
    region  = "us-east-1"
    profile = "go-noc-rd"
    #dynamodb_table = "terraform-backend"
  }
}

provider "aws" {
  alias   = "go_noc_rd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.go_noc_rd_profile
  default_tags {
    tags = {
      Created   = "08 Aug 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "rd_dev_k8s"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.rd_dev_k8s_profile
  default_tags {
    tags = {
      Created   = "08 Aug 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "go_prod_soc"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.go_prod_soc_profile
  default_tags {
    tags = {
      Created   = "08 Aug 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}
