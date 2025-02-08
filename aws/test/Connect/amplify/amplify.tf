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
      Created     = "05 Jun 2023"
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

resource "aws_amplify_app" "connect" {
  name        = "connect-tf"
  repository  = "https://bitbucket.org/compucomtechservices/connect-admin"
  oauth_token = var.bb_oath_token

  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm install --legacy-peer-deps --no-optional
        build:
          commands:
            - echo "AWS_BRANCH=$AWS_BRANCH" >> .env
            - echo "ACCESS_KEY=$ACCESS_KEY" >> .env
            - echo "SECRET_KEY=$SECRET_KEY" >> .env
            - echo "REGION=$REGION" >> .env
            - echo "COGNITO_USER_POOL_ID=$COGNITO_USER_POOL_ID" >> .env
            - echo "COGNITO_CLIENT_ID=$COGNITO_CLIENT_ID" >> .env
            - echo "COGNITO_CLIENT_SECRET=$COGNITO_CLIENT_SECRET" >> .env
            - echo "COGNITO_ISSUER=$COGNITO_ISSUER" >> .env
            - echo "NEXTAUTH_URL=$NEXTAUTH_URL" >> .env
            - echo "NEXTAUTH_SECRET=$NEXTAUTH_SECRET" >> .env
            - npm run build
            - npm run post-build
      artifacts:
        baseDirectory: .next
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  custom_rule {
    source = "/<*>"
    status = "200"
    target = "https://d2thwcs9jhv3eo.cloudfront.net/<*>"
  }
  custom_rule {
    source = "/<*>"
    status = "200"
    target = "https://d1k34zjp5u7lld.cloudfront.net/<*>"
  }
  custom_rule {
    source = "/<*>"
    status = "200"
    target = "https://d2kd1x7q7a32t3.cloudfront.net/<*>"
  }

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  enable_auto_branch_creation = true
  environment_variables = {
    "ACCESS_KEY" = "xyz",
    "ACCESS_SECRET" = "xyz",
    "AMPLIFY_NEXTJS_EXPERIMENTAL_TRACE" = "true",
    "ARTICLE_URL" = "https://compucom.nanorep.co/api/kb/v1/getArticleData",
    "CLOUDWATCH_GROUP" = "connect",
    "CLOUDWATCH_GROUP" = "connect",
    "COGNITO_CLIENT_ID" = "xyz",
    "COGNITO_CLIENT_SECRET" = "xyz",
    "COGNITO_ISSUER" = "xyz",
    "COGNITO_USER_POOL_ID" = "xyz",
    "CONNECT_TABLE" = "connect-table",
    "DYNAMO_ACCESS_KEY" = "xyz",
    "DYNAMO_SECRET_KEY" = "xyz",
    "HELP_SEARCH_URL" = "https://compucom.nanorep.co/api/kb/v1/search",
    "HELP_SESSION_URL" = "https://compucom.nanorep.co/api/widget/v1/hello",
    "LOG_STREAM_NAME" = "cf-logs",
    "MULESOFT_HOST" = "https://muleqc.diam.compucom.com/",
    "MULESOFT_KEY" = "",
    "NEXTAUTH_SECRET" = "connect",
    "NEXTAUTH_URL" = "https://main.d1yeasnhixqiui.amplifyapp.com/",
    "REGION" = "us-east-1",
    "TWILIO_CHAT_ACCOUNT" = "",
    "TWILIO_CHAT_FLOW" = "",
    "TWILIO_CHAT_STATUS_LINK" = "https://uat.compucomsupport.com/ivrv2/chat/",
    "_LIVE_UPDATES" = "[]"
  }

  # The default patterns added by the Amplify Console.
  auto_branch_creation_patterns = [
    "*",
    "*/**",
  ]

  auto_branch_creation_config {
    # Enable auto build for the created branch.
    enable_auto_build = true
  }

  iam_service_role_arn = "arn:aws:iam::300899438431:role/service-role/AmplifySSRLoggingRole-dquztpr55801q"
}

resource "aws_amplify_branch" "master" {
  app_id      = aws_amplify_app.connect.id
  branch_name = "master"
}

resource "aws_amplify_domain_association" "connect" {
  app_id      = aws_amplify_app.connect.id
  domain_name = "demo.connect.compucom.com"

  # https://demo.connect.compucom.com
  sub_domain {
    branch_name = aws_amplify_branch.master.branch_name
    prefix      = ""
  }
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

output "amplify_arn" {
  value = aws_amplify_app.connect.arn
}
