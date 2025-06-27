terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "fedramp-terraform-noc"
    key     = "aws/fedramp/falcon-hec/waf/tfstate"
    region  = "us-east-1"
    profile = "fedramp-tools-npri"
    #dynamodb_table = "terraform-backend"
  }
}

provider "aws" {
  alias   = "fedramp_k8s_npr"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_k8s_npr_profile
  default_tags {
    tags = {
      Created   = "9 Jun 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-611"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS WAF"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_npri"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_k8s_npri_profile
  default_tags {
    tags = {
      Created   = "9 Jun 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-611"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS WAF"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_prd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_k8s_prd_profile
  default_tags {
    tags = {
      Created   = "9 Jun 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-611"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS WAF"
    }
  }
}
