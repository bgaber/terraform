provider "aws" {
  alias   = "route53"
  region  = var.region
  profile = var.route53_cred_profile

  default_tags {
    tags = {
      Created     = "29 Jan 2024"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Connect"
      Portfolio   = "Digital Support"
      Incident    = "INC47573036"
    }
  }
}