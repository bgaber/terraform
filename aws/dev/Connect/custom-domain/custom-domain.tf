terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.cred_profile
  default_tags {
    tags = {
      Created     = "30 Jun 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Connect"
      Incident    = "INC0123456789"
    }
  }
}

provider "aws" {
  alias   = "route53"
  region  = var.region
  profile = var.route53_cred_profile

  default_tags {
    tags = {
      Created     = "30 Jun 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Connect"
      Incident    = "INC0123456789"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_caller_identity" "route53" {
  provider = aws.route53
}

# THIS WILL REPLACE ANY EXISTING CUSTOM DOMAINS
resource "aws_amplify_domain_association" "connect" {
  app_id      = var.app_id
  domain_name = "connect.compucom.com"
  enable_auto_sub_domain = true
  wait_for_verification = false

  dynamic "sub_domain" {
    for_each = var.branches
    content {
      branch_name = sub_domain.value
      prefix      = sub_domain.key
    }
  }
}

resource "aws_route53_record" "connect" {
  provider = aws.route53
  zone_id  = var.hosted_zone_id

  for_each = var.branches
  name     = "${each.key}.connect"
  
  ttl      = 300
  type     = "CNAME"
  records  = [var.cloudfront]
}

output "current_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "route53_account_id" {
  value = data.aws_caller_identity.route53.account_id
}

output "route53_names" {
  description = "Route 53 CNAME Record"
  #value = aws_route53_record.connect[*].name
  value = [ for r53_rcd in aws_route53_record.connect: r53_rcd.name ]
}

output "route53_fqdns" {
  description = "Route 53 FQDNs"
  value = [ for r53_rcd in aws_route53_record.connect: r53_rcd.fqdn ]
}

# No data sources for Amplify
# output "dns_record" {
#   value = data.aws_amplify_domain_association.connect.dns_record
# }

# output "verification_status" {
#   value = data.aws_amplify_domain_association.connect.verified
# }
