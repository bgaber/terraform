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
      Created     = "01 Jun 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Connect"
      Incident    = "INC46289710"
    }
  }
}

provider "aws" {
  alias   = "switch_role"
  region  = var.region
  profile = var.switch_role_cred_profile

  default_tags {
    tags = {
      Created     = "01 Jun 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Connect"
      Incident    = "INC46289710"
    }
  }
}

data "aws_caller_identity" "shared" {}

data "aws_caller_identity" "switch" {
  provider = aws.switch_role
}

locals {
    shared_account_id    = data.aws_caller_identity.shared.account_id
    switched_account_id  = data.aws_caller_identity.switch.account_id
}

resource "aws_iam_user" "user_one" {
  name = "da220419"
  tags = {
    Name  = "Daniel Alejandro Angulo Angeles"
    email = "DanielAlejandro.AnguloAngeles@compucom.com"
  }
}

resource "aws_iam_group" "connect_dev" {
  name = var.iam_group_name
}

resource "aws_iam_group_membership" "team" {
  name = "connect-dev-group-membership"

  users = [
    aws_iam_user.user_one.name,
  ]

  group = aws_iam_group.connect_dev.name
}

resource "aws_iam_policy" "assume_role_policy" {
  name = var.assume_role_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "AssumeContentCreatorRole",
        Effect : "Allow",
        Resource : "arn:aws:iam::${local.switched_account_id}:role/${var.assumed_role}"
        Action : "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "cc-attach" {
  group      = aws_iam_group.connect_dev.name
  policy_arn = aws_iam_policy.assume_role_policy.arn
}

resource "aws_iam_group_policy_attachment" "custom-iam-access-key-and-MFA" {
  group      = aws_iam_group.connect_dev.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/custom-iam-access-key-and-MFA"
}

resource "aws_iam_group_policy_attachment" "deny-ssm" {
  group      = aws_iam_group.connect_dev.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/DenySSM"
}

resource "aws_iam_group_policy_attachment" "force-mfa" {
  group      = aws_iam_group.connect_dev.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/Force_MFA"
}

resource "aws_iam_group_policy_attachment" "iam-user-change-password" {
  group      = aws_iam_group.connect_dev.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_role" "assumed_role" {
  provider = aws.switch_role
  name     = var.assumed_role

  # Trusted entities
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::${local.shared_account_id}:root"
        },
        "Action": "sts:AssumeRole",
        "Condition": {
            "Bool": {
                "aws:MultiFactorAuthPresent": "true"
            }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "cognito-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
}

resource "aws_iam_role_policy_attachment" "lambda-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "dynamo-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "route53-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "amplify-admin-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess-Amplify"
}

output "group_arn" {
  value = aws_iam_group.connect_dev.arn
}

output "group_name" {
  value = aws_iam_group.connect_dev.name
}

output "assumed_role_id" {
  value = aws_iam_role.assumed_role.id
}

output "assumed_role_arn" {
  value = aws_iam_role.assumed_role.arn
}

output "assumed_role_name" {
  value = aws_iam_role.assumed_role.name
}