terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    dns = {
      source = "hashicorp/dns"
      version = "3.4.1"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-cc"
    key     = "aws/others/dns/tfstate"
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
      Created     = "29 Jul 2024"
      Creator     = "Brian Gaber"
      ManagedBy   = "Terraform"
      Owner       = "Brian Gaber"
      Application = "SRETools"
    }
  }
}

provider "dns" {
  update {
    server = "spwawsinfdc01" # Using the hostname is important in order for an SPN to match
    gssapi {
      realm    = "compucom.local"
      username = "compucom\\$ansiblewinaws"
      keytab   = "/path/to/keytab"
    }
  }
}