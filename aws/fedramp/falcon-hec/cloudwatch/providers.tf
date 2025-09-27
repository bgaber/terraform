terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "fedramp-terraform-noc"
    key     = "aws/fedramp/falcon-hec/cloudwatch/tfstate"
    region  = "us-east-1"
    profile = "fedramp-tools-npri"
    #dynamodb_table = "terraform-backend"
  }
}

provider "aws" {
  alias   = "fedramp_agencysim_npri"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_agencysim_npri_profile
  default_tags {
    tags = {
      Created   = "11 Sept 2025"
      Creator   = "Georges Homsy"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1123"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS CloudWatch"
    }
  }
}

provider "aws" {
  alias   = "fedramp_integration_npr"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_integration_npr_profile
  default_tags {
    tags = {
      Created   = "11 Sept 2025"
      Creator   = "Georges Homsy"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1123"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS CloudWatch"
    }
  }
}

provider "aws" {
  alias   = "fedramp_integration_npri"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_integration_npri_profile
  default_tags {
    tags = {
      Created   = "11 Sept 2025"
      Creator   = "Georges Homsy"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1123"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS CloudWatch"
    }
  }
}

provider "aws" {
  alias   = "fedramp_integration_prd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_integration_prd_profile
  default_tags {
    tags = {
      Created   = "11 Sept 2025"
      Creator   = "Georges Homsy"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1123"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS CloudWatch"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_npr"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_k8s_npr_profile
  default_tags {
    tags = {
      Created   = "11 Sept 2025"
      Creator   = "Georges Homsy"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1123"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS CloudWatch"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_npri"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_k8s_npri_profile
  default_tags {
    tags = {
      Created   = "11 Sept 2025"
      Creator   = "Georges Homsy"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1123"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS CloudWatch"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_prd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_k8s_prd_profile
  default_tags {
    tags = {
      Created   = "11 Sept 2025"
      Creator   = "Georges Homsy"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1123"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS CloudWatch"
    }
  }
}

provider "aws" {
  alias   = "fedramp_security"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_security_profile
  default_tags {
    tags = {
      Created   = "11 Sept 2025"
      Creator   = "Georges Homsy"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1123"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS CloudWatch"
    }
  }
}

provider "aws" {
  alias   = "fedramp_tools_npri"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_tools_npri_profile
  default_tags {
    tags = {
      Created   = "11 Sept 2025"
      Creator   = "Georges Homsy"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1123"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS CloudWatch"
    }
  }
}

provider "aws" {
  alias   = "fedramp_tools_prd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_tools_prd_profile
  default_tags {
    tags = {
      Created   = "11 Sept 2025"
      Creator   = "Georges Homsy"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1123"
      Purpose   = "Setup CrowdStrike Falcon HEC Data Connector for AWS CloudWatch"
    }
  }
}
