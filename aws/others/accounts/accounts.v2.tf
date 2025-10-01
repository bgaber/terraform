# made by Brian
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  alias   = "fedramp_access_analyzer"
  region  = var.region
  profile = var.fedramp_access_analyzer_profile
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

data "aws_caller_identity" "fedramp_access_analyzer" {
  provider = aws.fedramp_access_analyzer
}

data "aws_caller_identity" "fedramp_edge_nw_npr" {
  provider = aws.fedramp_edge_nw_npr
}

data "aws_caller_identity" "fedramp_edge_nw_prd" {
  provider = aws.fedramp_edge_nw_prd
}

data "aws_caller_identity" "fedramp_integration_npr" {
  provider = aws.fedramp_integration_npr
}

data "aws_caller_identity" "fedramp_integration_npri" {
  provider = aws.fedramp_integration_npri
}

data "aws_caller_identity" "fedramp_integration_prd" {
  provider = aws.fedramp_integration_prd
}

data "aws_caller_identity" "fedramp_k8s_npr" {
  provider = aws.fedramp_k8s_npr
}

data "aws_caller_identity" "fedramp_k8s_npri" {
  provider = aws.fedramp_k8s_npri
}

data "aws_caller_identity" "fedramp_k8s_prd" {
  provider = aws.fedramp_k8s_prd
}

data "aws_caller_identity" "fedramp_tools" {
  provider = aws.fedramp_tools
}

output "fedramp_access_analyzer_account_id" {
  value = data.aws_caller_identity.fedramp_access_analyzer.account_id
}

output "fedramp_edge_nw_npr_account_id" {
  value = data.aws_caller_identity.fedramp_edge_nw_npr.account_id
}

output "fedramp_edge_nw_prd_account_id" {
  value = data.aws_caller_identity.fedramp_edge_nw_prd.account_id
}

output "fedramp_integration_npr_account_id" {
  value = data.aws_caller_identity.fedramp_integration_npr.account_id
}

output "fedramp_integration_npri_account_id" {
  value = data.aws_caller_identity.fedramp_integration_npri.account_id
}

output "fedramp_integration_prd_account_id" {
  value = data.aws_caller_identity.fedramp_integration_prd.account_id
}

output "fedramp_k8s_npr_account_id" {
  value = data.aws_caller_identity.fedramp_k8s_npr.account_id
}

output "fedramp_k8s_npri_account_id" {
  value = data.aws_caller_identity.fedramp_k8s_npri.account_id
}

output "fedramp_k8s_prd_account_id" {
  value = data.aws_caller_identity.fedramp_k8s_prd.account_id
}

output "fedramp_tools_account_id" {
  value = data.aws_caller_identity.fedramp_tools.account_id
}