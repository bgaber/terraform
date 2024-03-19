# made by Brian
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
  profile = var.shared_cred_profile
}

provider "aws" {
  alias   = "prod"
  region  = var.region
  profile = var.prod_cred_profile
}

provider "aws" {
  alias   = "test"
  region  = var.region
  profile = var.test_cred_profile
}

provider "aws" {
  alias   = "dev"
  region  = var.region
  profile = var.dev_cred_profile
}

provider "aws" {
  alias   = "canada"
  region  = var.region
  profile = var.canada_cred_profile
}

provider "aws" {
  alias   = "sandbox"
  region  = var.region
  profile = var.sandbox_cred_profile
}

provider "aws" {
  alias   = "twilio"
  region  = var.region
  profile = var.twilio_cred_profile
}

provider "aws" {
  alias   = "pkg_factory"
  region  = var.region
  profile = var.pkg_factory_cred_profile
}

provider "aws" {
  alias   = "aish"
  region  = var.region
  profile = var.aish_cred_profile
}

data "aws_caller_identity" "shared" {}

data "aws_caller_identity" "prod" {
  provider = aws.prod
}

data "aws_caller_identity" "test" {
  provider = aws.test
}

data "aws_caller_identity" "dev" {
  provider = aws.dev
}

data "aws_caller_identity" "canada" {
  provider = aws.canada
}

data "aws_caller_identity" "sandbox" {
  provider = aws.sandbox
}

data "aws_caller_identity" "twilio" {
  provider = aws.twilio
}

data "aws_caller_identity" "pkg_factory" {
  provider = aws.pkg_factory
}

data "aws_caller_identity" "aish" {
  provider = aws.aish
}

output "shared_account_id" {
  value = data.aws_caller_identity.shared.account_id
}

# output "caller_arn" {
#   value = data.aws_caller_identity.shared.arn
# }

# output "caller_user" {
#   value = data.aws_caller_identity.shared.user_id
# }

output "prod_account_id" {
  value = data.aws_caller_identity.prod.account_id
}

output "test_account_id" {
  value = data.aws_caller_identity.test.account_id
}

output "dev_account_id" {
  value = data.aws_caller_identity.dev.account_id
}

output "canada_account_id" {
  value = data.aws_caller_identity.canada.account_id
}

output "sandbox_account_id" {
  value = data.aws_caller_identity.sandbox.account_id
}

output "twilio_account_id" {
  value = data.aws_caller_identity.twilio.account_id
}

output "pkg_factory_account_id" {
  value = data.aws_caller_identity.pkg_factory.account_id
}

output "aish_account_id" {
  value = data.aws_caller_identity.aish.account_id
}