terraform {
  required_providers {
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
      Created   = "09 Dec 2024"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Lucas Cardim"
      JIRA      = "NOC-1239"
      Purpose   = "Rotation of the Elite Monitoring Account"
    }
  }
}