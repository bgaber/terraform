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
      Created     = "12 Jun 2023"
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

resource "aws_iam_role_policy" "managed_policy" {
  name = "connect_pretoken_generator_test"
  role = aws_iam_role.iam_for_lambda.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
          Sid: "VisualEditor0",
          Effect: "Allow",
          Action: [
              "ec2:CreateNetworkInterface",
              "ec2:DeleteNetworkInterface",
              "logs:CreateLogGroup"
          ],
          Resource: [
              "arn:aws:logs:us-east-1:${local.account_id}:*",
              "arn:aws:ec2:us-east-1:${local.account_id}:*"
          ]
        },
        {
          Sid: "VisualEditor1",
          Effect: "Allow",
          Action: "ec2:DescribeNetworkInterfaces",
          Resource: "*"
        },
        {
          Sid: "VisualEditor2",
          Effect: "Allow",
          Action: [
              "logs:CreateLogStream",
              "logs:PutLogEvents"
          ],
          Resource: "arn:aws:logs:us-east-1:${local.account_id}:log-group:/aws/lambda/connect-pretoken-generator-test:*"
        }
    ]
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "pre_token_gen_lambda" {
  description   = "Connect Cognito User Pool Pretoken Generator Function"
  environment {
    variables = {
      MULESOFT_HOST = "https://muleqc.diam.compucom.com/"
      MULESOFT_KEY  = "NjU1YTk4YzYwNzc0NDQxY2IyN2Q5MDk2MmRmMDYyMzQ6MjE4MkM3YTQzM0MyNGE4ODhhMzYwQzRGNjM0QjA1Zjg"
    }
  }
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  s3_bucket     = var.connect_s3_bucket
  s3_key        = var.pre_tok_gen_lambda_archive
  runtime       = "nodejs18.x"
  timeout       = "3"
  tracing_config {
    mode = "Active"
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

output "lambda_arn" {
  value = aws_lambda_function.pre_token_gen_lambda.arn
}
