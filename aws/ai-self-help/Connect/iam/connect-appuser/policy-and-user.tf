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
  profile = var.login_cred_profile
  default_tags {
    tags = {
      Created     = "12 Jun 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Connect"
      Incident    = "INC46289710"
    }
  }
}

data "aws_caller_identity" "test" {}

locals {
    test_account_id    = data.aws_caller_identity.test.account_id
}

resource "aws_iam_user" "app_user" {
  name = var.user_name
  tags = {
    Name    = "Amplify App User Name"
    Purpose = "Connect application access dynamodb and s3 bucket using access key"
  }
}

resource "aws_iam_policy" "appuser_policy" {
  name = var.policy_name

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PushLogs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:us-east-1:${local.test_account_id}:log-group:/aws/amplify/*:log-stream:*",
                "arn:aws:logs:us-east-1:${local.test_account_id}:log-group:/aws/lambda/connect-pre-token-generator:*"
            ]
        },
        {
            "Sid": "CreateLogGroup",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": [
                "arn:aws:logs:us-east-1:${local.test_account_id}:log-group:/aws/amplify/*",
                "arn:aws:logs:us-east-1:${local.test_account_id}:log-group:/aws/lambda/*"
            ]
        },
        {
            "Sid": "DescribeLogGroups",
            "Effect": "Allow",
            "Action": "logs:DescribeLogGroups",
            "Resource": "arn:aws:logs:us-east-1:${local.test_account_id}:log-group:*"
        },
        {
            "Sid": "CognitoIdP",
            "Action": "cognito-idp:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "CognitoIdentity",
            "Action": "cognito-identity:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "DynamoDB",
            "Action": "dynamodb:*",
            "Effect": "Allow",
            "Resource": "arn:aws:dynamodb:us-east-1:${local.test_account_id}:table/connect-table"
        },
        {
            "Sid": "LogosS3",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::connect-admin-logos/*"
            ]
        }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "appuser-attach" {
  user       = aws_iam_user.app_user.name
  policy_arn = aws_iam_policy.appuser_policy.arn
}

output "appuser_arn" {
  value = aws_iam_user.app_user.arn
}

output "appuser_name" {
  value = aws_iam_user.app_user.name
}

output "appuser_policy_arn" {
  value = aws_iam_policy.appuser_policy.arn
}

output "appuser_policy_name" {
  value = aws_iam_policy.appuser_policy.name
}

output "appuser_policy" {
  value = aws_iam_policy.appuser_policy.policy
}