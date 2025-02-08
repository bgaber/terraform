terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/shared/transit-gateway/tfstate"
    region  = "us-east-1"
    profile = "Shared"
    dynamodb_table = "terraform-backend"
  }
}

# Local account creates the ca-central-1 transit gateway and accepts the VPC attachment.
provider "aws" {
  alias   = "local"
  region  = var.local_region
  profile = var.canada_cred_profile
  default_tags {
    tags = {
      Created     = "01 Mar 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Jason Boomer"
      Application = "SRETools"
    }
  }
}

# Peer account owns the existing us-east-1 transit gateway
provider "aws" {
  alias   = "peer"
  region  = var.peer_region
  profile = var.shared_cred_profile
  default_tags {
    tags = {
      Created     = "01 Mar 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Jason Boomer"
      Application = "SRETools"
    }
  }
}

# Master account is the Organizations Management Account
provider "aws" {
  alias   = "master"
  region  = var.peer_region
  profile = var.master_cred_profile
  default_tags {
    tags = {
      Created     = "01 Mar 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Jason Boomer"
      Application = "SRETools"
    }
  }
}