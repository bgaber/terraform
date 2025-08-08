terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "fedramp-terraform-noc"
    key     = "aws/fedramp/cloud-custodian/tfstate"
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
      Created   = "31 Jul 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "fedramp_integration_npr"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_integration_npr_profile
  default_tags {
    tags = {
      Created   = "31 Jul 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "fedramp_integration_npri"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_integration_npri_profile
  default_tags {
    tags = {
      Created   = "31 Jul 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "fedramp_integration_prd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_integration_prd_profile
  default_tags {
    tags = {
      Created   = "31 Jul 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_npr"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_k8s_npr_profile
  default_tags {
    tags = {
      Created   = "31 Jul 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_npri"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_k8s_npri_profile
  default_tags {
    tags = {
      Created   = "31 Jul 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_prd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_k8s_prd_profile
  default_tags {
    tags = {
      Created   = "31 Jul 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "fedramp_network"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_network_profile
  default_tags {
    tags = {
      Created   = "31 Jul 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "fedramp_network_prd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_network_prd_profile
  default_tags {
    tags = {
      Created   = "31 Jul 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "fedramp_security"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_security_profile
  default_tags {
    tags = {
      Created   = "31 Jul 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "fedramp_tools_npri"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_tools_npri_profile
  default_tags {
    tags = {
      Created   = "31 Jul 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}

provider "aws" {
  alias   = "fedramp_tools_prd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_tools_prd_profile
  default_tags {
    tags = {
      Created   = "31 Jul 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-1070"
      Purpose   = "Unused credentials should be deactivated or removed"
    }
  }
}
