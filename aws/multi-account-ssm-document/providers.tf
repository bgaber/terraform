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
  default_tags {
    tags = {
      Created   = "19 Mar 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-603"
      Purpose   = "Setup and install Crowdstrike EDR for EC2 instances"
    }
  }
}

provider "aws" {
  alias   = "fedramp_edge_nw_npr"
  region  = var.region
  profile = var.fedramp_edge_nw_npr_profile
  default_tags {
    tags = {
      Created   = "19 Mar 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-603"
      Purpose   = "Setup and install Crowdstrike EDR for EC2 instances"
    }
  }
}

provider "aws" {
  alias   = "fedramp_edge_nw_prd"
  region  = var.region
  profile = var.fedramp_edge_nw_prd_profile
  default_tags {
    tags = {
      Created   = "19 Mar 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-603"
      Purpose   = "Setup and install Crowdstrike EDR for EC2 instances"
    }
  }
}

provider "aws" {
  alias   = "fedramp_integration_npr"
  region  = var.region
  profile = var.fedramp_integration_npr_profile
  default_tags {
    tags = {
      Created   = "19 Mar 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-603"
      Purpose   = "Setup and install Crowdstrike EDR for EC2 instances"
    }
  }
}

provider "aws" {
  alias   = "fedramp_integration_npri"
  region  = var.region
  profile = var.fedramp_integration_npri_profile
  default_tags {
    tags = {
      Created   = "19 Mar 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-603"
      Purpose   = "Setup and install Crowdstrike EDR for EC2 instances"
    }
  }
}

provider "aws" {
  alias   = "fedramp_integration_prd"
  region  = var.region
  profile = var.fedramp_integration_prd_profile
  default_tags {
    tags = {
      Created   = "19 Mar 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-603"
      Purpose   = "Setup and install Crowdstrike EDR for EC2 instances"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_npr"
  region  = var.region
  profile = var.fedramp_k8s_npr_profile
  default_tags {
    tags = {
      Created   = "19 Mar 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-603"
      Purpose   = "Setup and install Crowdstrike EDR for EC2 instances"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_npri"
  region  = var.region
  profile = var.fedramp_k8s_npri_profile
  default_tags {
    tags = {
      Created   = "19 Mar 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-603"
      Purpose   = "Setup and install Crowdstrike EDR for EC2 instances"
    }
  }
}

provider "aws" {
  alias   = "fedramp_k8s_prd"
  region  = var.region
  profile = var.fedramp_k8s_prd_profile
  default_tags {
    tags = {
      Created   = "19 Mar 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-603"
      Purpose   = "Setup and install Crowdstrike EDR for EC2 instances"
    }
  }
}

provider "aws" {
  alias   = "fedramp_tools"
  region  = var.region
  profile = var.fedramp_tools_profile
  default_tags {
    tags = {
      Created   = "19 Mar 2025"
      Creator   = "Brian Gaber"
      ManagedBy = "Terraform"
      Owner     = "Colin Krane"
      JIRA      = "FED-603"
      Purpose   = "Setup and install Crowdstrike EDR for EC2 instances"
    }
  }
}
