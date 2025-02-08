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
      Created     = "12 Jul 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rick Kenyon"
      Application = "Salesforce"
      Incident    = "INC46606351"
    }
  }
}

provider "aws" {
  alias   = "switch_role"
  region  = var.region
  profile = var.switch_role_cred_profile

  default_tags {
    tags = {
      Created     = "12 Jul 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rick Kenyon"
      Application = "Salesforce"
      Incident    = "INC46606351"
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
  name = "gkrishna"
  tags = {
    Name  = "Gopi Krishnakumar"
    email = "gopi.krishnakumar@compucom.com"
  }
}

resource "aws_iam_user" "user_two" {
  name = "pbojji"
  tags = {
    Name  = "Phani Bojji"
    email = "phani.bojji@compucom.com"
  }
}

resource "aws_iam_user" "user_three" {
  name = "nh214281"
  tags = {
    Name  = "Nisha Haswani"
    email = "nisha.haswani@compucom.com"
  }
}

resource "aws_iam_group" "salesforce_gp" {
  name = var.iam_group_name
}

resource "aws_iam_group_membership" "team" {
  name = "salesforce-group-membership"

  users = [
    aws_iam_user.user_one.name,
    aws_iam_user.user_two.name,
    aws_iam_user.user_three.name,
  ]

  group = aws_iam_group.salesforce_gp.name
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
  group      = aws_iam_group.salesforce_gp.name
  policy_arn = aws_iam_policy.assume_role_policy.arn
}

resource "aws_iam_group_policy_attachment" "custom-iam-access-key-and-MFA" {
  group      = aws_iam_group.salesforce_gp.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/custom-iam-access-key-and-MFA"
}

resource "aws_iam_group_policy_attachment" "deny-ssm" {
  group      = aws_iam_group.salesforce_gp.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/DenySSM"
}

resource "aws_iam_group_policy_attachment" "force-mfa" {
  group      = aws_iam_group.salesforce_gp.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/Force_MFA"
}

resource "aws_iam_group_policy_attachment" "iam-user-change-password" {
  group      = aws_iam_group.salesforce_gp.name
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

resource "aws_iam_policy" "s3_iam_policy" {
  provider    = aws.switch_role
  name        = "salesforce_s3_policy"
  description = join(" ", [var.s3_bucket, "policy"])

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = [
            "arn:aws:s3:::${var.s3_bucket}",
            "arn:aws:s3:::${var.s3_bucket}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = aws_iam_policy.s3_iam_policy.arn
}

output "group_arn" {
  value = aws_iam_group.salesforce_gp.arn
}

output "group_name" {
  value = aws_iam_group.salesforce_gp.name
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