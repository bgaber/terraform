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
      Created     = "26 May 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Connect"
      Incident    = "INC0123456789"
    }
  }
}

data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

data "aws_lambda_function" "pre_tok_gen" {
  function_name = "connect-pre-token-generator"
}

resource "aws_lambda_permission" "allow_pre_tok_gen" {
  statement_id   = "AllowExecutionFromCognito"
  action         = "lambda:InvokeFunction"
  function_name  = data.aws_lambda_function.pre_tok_gen.arn
  principal      = "cognito-idp.amazonaws.com"
  source_account = local.account_id
  source_arn     = aws_cognito_user_pool.connect_user_pool.arn
}

resource "aws_cognito_user_pool" "connect_user_pool" {
  name = var.user_pool_name

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  auto_verified_attributes = ["email"]

  email_configuration {
    email_sending_account = "DEVELOPER"
    from_email_address = "no-reply@compucom.com" # domain must be verified in SES
    source_arn = join("", ["arn:aws:ses:us-east-1:", local.account_id, ":identity/compucom.com"])
  }

  lambda_config {
    pre_token_generation = data.aws_lambda_function.pre_tok_gen.arn
  }
  mfa_configuration          = "OFF"

  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "email"
    required            = true
  }
  schema {
    name                     = "clientId"
    attribute_data_type      = "Number"
    mutable                  = true
    required                 = false
    number_attribute_constraints {
      min_value = 0
      max_value = 1000000
    }
  }
  
  sms_authentication_message = "Your authentication code is {####}."
}

resource "aws_cognito_user_pool_client" "connect_user_pool_client" {
  name = var.user_pool_app_client_name
  access_token_validity                = 5
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "phone","profile"]
  callback_urls                        = ["http://localhost:3000/api/auth/callback/cognito", "https://dev.d1tcinvvgd0ott.amplifyapp.com/api/auth/callback/cognito"]
  enable_token_revocation              = true
  generate_secret                      = true
  id_token_validity                    = 5
  prevent_user_existence_errors        = "ENABLED"
  supported_identity_providers         = [aws_cognito_identity_provider.compucom_provider.provider_name]
  token_validity_units {
    access_token = "minutes"
    id_token = "minutes"
  }
  user_pool_id = aws_cognito_user_pool.connect_user_pool.id
}

resource "aws_cognito_identity_provider" "compucom_provider" {
  user_pool_id  = aws_cognito_user_pool.connect_user_pool.id
  provider_name = "compucom"
  provider_type = "SAML"

  provider_details = {
    MetadataURL = join ("", ["https://", var.connect_s3_bucket , ".s3.amazonaws.com/", var.saml_file])
  }

  attribute_mapping = {
    name         = "firstName"
    phone_number = "phoneNumber"
    given_name   = "firstName"
    family_name  = "lastName"
    email        = "emailAddress"
  }
}

output "cognito_user_pool_arn" {
  value = aws_cognito_user_pool.connect_user_pool.arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}
