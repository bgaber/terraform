terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
  backend "s3" {
    bucket  = "terraform-backend-for-tecsys"
    key     = "datadog/elite-password-rotation/tfstate"
    region  = "us-east-1"
  }
}

provider "datadog" {
  default_tags {
    tags = {
      Created   = "25 Feb 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "NOC-1239"
      Purpose   = "Rotation of the Elite Monitoring Account"
    }
  }
}