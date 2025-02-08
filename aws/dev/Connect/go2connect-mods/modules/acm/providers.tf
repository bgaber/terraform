provider "aws" {
  alias   = "r53_role"
  region  = var.region
  profile = var.r53_profile
  default_tags {
    tags = {
      Created     = "22 Apr 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Connect"
      Incident    = "INC48919425"
      Portfolio   = "Digital Support"
    }
  }
}