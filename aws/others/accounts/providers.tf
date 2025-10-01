terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  alias   = "fedramp_security"
  region  = var.region
  profile = var.fedramp_security_profile
}

provider "aws" {
  alias   = "fedramp_edge_nw_npr"
  region  = var.region
  profile = var.fedramp_edge_nw_npr_profile
}

provider "aws" {
  alias   = "fedramp_edge_nw_prd"
  region  = var.region
  profile = var.fedramp_edge_nw_prd_profile
}

provider "aws" {
  alias   = "fedramp_integration_npr"
  region  = var.region
  profile = var.fedramp_integration_npr_profile
}

provider "aws" {
  alias   = "fedramp_integration_npri"
  region  = var.region
  profile = var.fedramp_integration_npri_profile
}

provider "aws" {
  alias   = "fedramp_integration_prd"
  region  = var.region
  profile = var.fedramp_integration_prd_profile
}

provider "aws" {
  alias   = "fedramp_k8s_npr"
  region  = var.region
  profile = var.fedramp_k8s_npr_profile
}

provider "aws" {
  alias   = "fedramp_k8s_npri"
  region  = var.region
  profile = var.fedramp_k8s_npri_profile
}

provider "aws" {
  alias   = "fedramp_k8s_prd"
  region  = var.region
  profile = var.fedramp_k8s_prd_profile
}

provider "aws" {
  alias   = "fedramp_tools"
  region  = var.region
  profile = var.fedramp_tools_profile
}
