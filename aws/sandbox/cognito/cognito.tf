terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.39"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.cred_profile
  default_tags {
    tags = {
      Created     = var.creation_date
      CreatedBy   = var.created_by
      Owner       = var.owner
      Application = var.application
      Environment = "Sandbox"
    }
  }
}

resource "aws_cognito_user_pool" "pool" {
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

  admin_create_user_config {
    allow_admin_create_user_only = true
    invite_message_template {
      email_message = "Your username is {username} and temporary password is {####}."
      email_subject = "Your temporary password"
      sms_message   = "Your username is {username} and temporary password is {####}."
    }
  }

  auto_verified_attributes = ["email"]

  lambda_config {
    pre_token_generation = "arn:aws:lambda:us-east-1:655690556973:function:careguard-pretoken-generator-test"
    user_migration       = "arn:aws:lambda:us-east-1:655690556973:function:careguard-user-migration-test"
  }

  mfa_configuration     = "ON"

  schema {
    attribute_data_type = "Number"
    name = "cgc"
    number_attribute_constraints {
        max_value = 256
        min_value = 1
    }
    required = false
    mutable = true
  }

  software_token_mfa_configuration {
    enabled = true
  }

  # tags {
  #   Created     = var.creation_date
  #   CreatedBy   = var.created_by
  #   Owner       = var.owner
  #   Application = var.application
  # }

  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }
  
  username_configuration {
    case_sensitive = false
  } 

  verification_message_template { 
    default_email_option = "CONFIRM_WITH_CODE"
    email_message = "Your verification code is {####}."
    email_subject = "Your verification code"
    sms_message = "Your username is {username} and temporary password is {####}."
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = var.user_pool_app_client_name
  user_pool_id                         = aws_cognito_user_pool.pool.id
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "aws.cognito.signin.user.admin", "profile"]
  callback_urls                        = ["http://localhost:600/login"]
  logout_urls                          = ["http://localhost:600/login"]
  prevent_user_existence_errors        = "ENABLED"
  supported_identity_providers         = ["COGNITO", aws_cognito_identity_provider.compucom_provider.provider_name]
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain          = var.user_pool_domain_name
  certificate_arn = var.certificate_arn
  user_pool_id    = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_identity_provider" "compucom_provider" {
  user_pool_id  = aws_cognito_user_pool.pool.id
  provider_name = "compucom"
  provider_type = "SAML"

  provider_details = {
    #MetadataURL = "https://brian-careguard-bucket.s3.amazonaws.com/compucom-saml.xml"
    MetadataURL = join("", ["https://", var.s3_bucket, ".s3.amazonaws.com/", var.saml_file])
  }

  attribute_mapping = {
    name        = "firstName"
    given_name  = "firstName"
    family_name = "lastName"
    email       = "emailAddress"
  }
}

resource "aws_cognito_resource_server" "resource_svr" {
  identifier = var.user_pool_resource_server_name
  name       = var.user_pool_resource_server_name

  scope {
    scope_name        = "cgf"
    scope_description = "franchise"
  }
  scope {
    scope_name        = "cgi"
    scope_description = "internal"
  }
  scope  {
    scope_name        = "cgp"
    scope_description = "partner"
  }
  scope {
    scope_name        = "cgc"
    scope_description = "customer"
  }

  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_ui_customization" "user_pool_ui" {
  client_id = aws_cognito_user_pool_client.client.id

  image_file = filebase64("2022-CompuCom-logo-full-colore.png")

  # Refer to the aws_cognito_user_pool_domain resource's
  # user_pool_id attribute to ensure it is in an 'Active' state
  user_pool_id = aws_cognito_user_pool_domain.domain.user_pool_id
}

resource "aws_route53_record" "cognito_dns_record" {
  zone_id = var.r53_hosted_zone_id
  name    = var.custom_domain_name
  type    = "A"

  alias {
    name                   = aws_cognito_user_pool_domain.domain.cloudfront_distribution_arn
    zone_id                = "Z2FDTNDATAQYW2" # from AWS docs
    evaluate_target_health = true
  }
}


output "user_pool_arn" {
  value = aws_cognito_user_pool.pool.arn
}

output "user_pool_id" {
  value = aws_cognito_user_pool.pool.id
}

output "user_pool_domain" {
  value = aws_cognito_user_pool.pool.domain
}

output "user_pool_endpoint" {
  value = aws_cognito_user_pool.pool.endpoint
}

output "user_pool_tags" {
  value = aws_cognito_user_pool.pool.tags_all
}