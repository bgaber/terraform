# The purpose of this Terraform code is to give certain users access in the Shared, Prod and Test AWS accounts for the Bonitassoft application

data "aws_caller_identity" "shared" {}

data "aws_caller_identity" "prod_alias" {
  provider = aws.prod_alias
}

data "aws_caller_identity" "test_alias" {
  provider = aws.test_alias
}

locals {
    shared_account_id    = data.aws_caller_identity.shared.account_id
    prod_switched_account_id  = data.aws_caller_identity.prod_alias.account_id
    test_switched_account_id  = data.aws_caller_identity.test_alias.account_id
}

# User
resource "aws_iam_user" "user_one" {
  name = var.iam_user_name
  tags = {
    Name  = var.iam_full_name
    email = var.iam_user_email
  }
}

resource "aws_iam_group" "this" {
  name = var.iam_group_name
}

resource "aws_iam_group_membership" "this" {
  name = "${var.iam_group_name}-group-membership"

  users = [
    aws_iam_user.user_one.name,
  ]

  group = aws_iam_group.this.name
}

# Shared Account IAM Group Assume Role Policy to Prod Account
resource "aws_iam_policy" "prod_assume_role_policy" {
  name = join("-", ["Prod", var.assume_role_policy_name])

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "ProdAssumeRole",
        Effect : "Allow",
        Resource : "arn:aws:iam::${local.prod_switched_account_id}:role/${var.assumed_role}"
        Action : "sts:AssumeRole"
      },
    ]
  })
}

# Shared Account IAM Group Assume Role Policy to Test Account
resource "aws_iam_policy" "test_assume_role_policy" {
  name = join("-", ["Test", var.assume_role_policy_name])

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "TestAssumeRole",
        Effect : "Allow",
        Resource : "arn:aws:iam::${local.test_switched_account_id}:role/${var.assumed_role}"
        Action : "sts:AssumeRole"
      },
    ]
  })
}

# Shared Account IAM Group Permission policies
resource "aws_iam_group_policy_attachment" "prod_policy_attach" {
  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.prod_assume_role_policy.arn
}

resource "aws_iam_group_policy_attachment" "test_policy_attach" {
  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.test_assume_role_policy.arn
}

resource "aws_iam_group_policy_attachment" "custom_iam_access_key_and_MFA" {
  group      = aws_iam_group.this.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/custom-iam-access-key-and-MFA"
}

resource "aws_iam_group_policy_attachment" "deny_ssm" {
  group      = aws_iam_group.this.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/DenySSM"
}

resource "aws_iam_group_policy_attachment" "force_mfa" {
  group      = aws_iam_group.this.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/Force_MFA"
}

resource "aws_iam_group_policy_attachment" "iam_user_change_password" {
  group      = aws_iam_group.this.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

# Prod Account Role that is assumed from Shared Account
resource "aws_iam_role" "prod_assumed_role" {
  provider = aws.prod_alias
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

# Prod Account Role Permissions policies
resource "aws_iam_role_policy_attachment" "prod_ec2_ro_access" {
  provider   = aws.prod_alias
  role       = aws_iam_role.prod_assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "prod_rds_ro_access" {
  provider   = aws.prod_alias
  role       = aws_iam_role.prod_assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "prod_cloudwatch_ro_access" {
  provider   = aws.prod_alias
  role       = aws_iam_role.prod_assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

# Test Account Role that is assumed from Shared Account
resource "aws_iam_role" "test_assumed_role" {
  provider = aws.test_alias
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

# Test Account Role Permissions policies
resource "aws_iam_role_policy_attachment" "test_ec2_ro_access" {
  provider   = aws.test_alias
  role       = aws_iam_role.test_assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "test_rds_ro_access" {
  provider   = aws.test_alias
  role       = aws_iam_role.test_assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "test_cloudwatch_ro_access" {
  provider   = aws.test_alias
  role       = aws_iam_role.test_assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

# Outputs
output "group_arn" {
  value = aws_iam_group.this.arn
}

output "group_name" {
  value = aws_iam_group.this.name
}

output "prod_assumed_role_id" {
  value = aws_iam_role.prod_assumed_role.id
}

output "prod_assumed_role_arn" {
  value = aws_iam_role.prod_assumed_role.arn
}

output "prod_assumed_role_name" {
  value = aws_iam_role.prod_assumed_role.name
}

output "test_assumed_role_id" {
  value = aws_iam_role.test_assumed_role.id
}

output "test_assumed_role_arn" {
  value = aws_iam_role.test_assumed_role.arn
}

output "test_assumed_role_name" {
  value = aws_iam_role.test_assumed_role.name
}