terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "datadog" {
  default_tags {
    tags = {
      Created   = "05 May 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      Purpose   = "Rotation of the Elite Monitoring Account"
    }
  }
}