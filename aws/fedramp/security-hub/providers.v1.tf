terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket  = "fedramp-terraform-noc"
    key     = "aws/fedramp/security-hub/tfstate"
    region  = "us-east-1"
    profile = "fedramp-tools-npri"
    #dynamodb_table = "terraform-backend"
  }
}

provider "aws" {
  alias   = "fedramp_edge_nw_npr"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_edge_nw_npr_profile
  default_tags {
    tags = {
      Created   = "11 Apr 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-639"
      Purpose   = "Setup AWS Security Hub"
    }
  }
}

provider "aws" {
  alias   = "fedramp_edge_nw_prd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_edge_nw_prd_profile
  default_tags {
    tags = {
      Created   = "11 Apr 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-639"
      Purpose   = "Setup AWS Security Hub"
    }
  }
}

provider "aws" {
  alias   = "fedramp_integration_npr"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_integration_npr_profile
  default_tags {
    tags = {
      Created   = "11 Apr 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-639"
      Purpose   = "Setup AWS Security Hub"
    }
  }
}

provider "aws" {
  alias   = "fedramp_integration_npri"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_integration_npri_profile
  default_tags {
    tags = {
      Created   = "11 Apr 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-639"
      Purpose   = "Setup AWS Security Hub"
    }
  }
}

provider "aws" {
  alias   = "fedramp_integration_prd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_integration_prd_profile
  default_tags {
    tags = {
      Created   = "11 Apr 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-639"
      Purpose   = "Setup AWS Security Hub"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_npr"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_k8s_npr_profile
  default_tags {
    tags = {
      Created   = "11 Apr 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-639"
      Purpose   = "Setup AWS Security Hub"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_npri"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_k8s_npri_profile
  default_tags {
    tags = {
      Created   = "11 Apr 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-639"
      Purpose   = "Setup AWS Security Hub"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_prd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_k8s_prd_profile
  default_tags {
    tags = {
      Created   = "11 Apr 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-639"
      Purpose   = "Setup AWS Security Hub"
    }
  }
}

provider "aws" {
  alias   = "fedramp_security"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_security_profile
  default_tags {
    tags = {
      Created   = "11 Apr 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-639"
      Purpose   = "Setup AWS Security Hub"
    }
  }
}

# provider "aws" {
#   alias   = "fedramp_tools"
#   region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
#   profile = var.fedramp_tools_profile
#   default_tags {
#     tags = {
#       Created   = "11 Apr 2025"
#       Creator   = "Brian Gaber"
#       ManagedBy = "Terraform"
#       Owner     = "Colin Krane"
#       JIRA      = "FED-639"
#       Purpose   = "Setup AWS Security Hub"
#     }
#   }
# }

provider "aws" {
  alias   = "fedramp_tools_npri"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_tools_npri_profile
  default_tags {
    tags = {
      Created   = "11 Apr 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-639"
      Purpose   = "Setup AWS Security Hub"
    }
  }
}

provider "aws" {
  alias   = "fedramp_tools_prd"
  region  = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
  profile = var.fedramp_tools_prd_profile
  default_tags {
    tags = {
      Created   = "10 Apr 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-641"
      Purpose   = "Setup AWS Security Hub"
    }
  }
}
