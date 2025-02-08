# The purpose of this Terraform code is to give certain users access in the Shared, Prod and Dev AWS accounts for the Bonitassoft application

data "aws_caller_identity" "shared" {}

data "aws_caller_identity" "dev_alias" {
  provider = aws.dev_alias
}

locals {
    shared_account_id    = data.aws_caller_identity.shared.account_id
    dev_switched_account_id  = data.aws_caller_identity.dev_alias.account_id
}

# User
resource "aws_iam_user" "users" {
  for_each = {for i, v in var.user_attributes:  i => v}
  name = each.value.username
  tags = {
    Name  = each.value.fullname
    email = each.value.email
  }
}

resource "aws_iam_group" "this" {
  name = var.iam_group_name
}

resource "aws_iam_group_membership" "this" {
  name = "${var.iam_group_name}-group-membership"
  users = values(aws_iam_user.users)[*].name
  group = aws_iam_group.this.name
}

# Shared Account IAM Group Assume Role Policy to AI-Self-Help Account
resource "aws_iam_policy" "dev_assume_role_policy" {
  name = join("-", [var.dev_switch_role_cred_profile, var.assume_role_policy_name])

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "DevAssumeRole",
        Effect : "Allow",
        Resource : "arn:aws:iam::${local.dev_switched_account_id}:role/${var.assumed_role}"
        Action : "sts:AssumeRole"
      },
    ]
  })
}

# Shared Account IAM Group Permission policies
resource "aws_iam_group_policy_attachment" "dev_policy_attach" {
  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.dev_assume_role_policy.arn
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

# AI-Self-Help Account Role that is assumed from Shared Account
resource "aws_iam_role" "dev_assumed_role" {
  provider = aws.dev_alias
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

# AI-Self-Help Account Role Permissions policies
resource "aws_iam_role_policy_attachment" "dev_power_user_access" {
  provider   = aws.dev_alias
  role       = aws_iam_role.dev_assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# Outputs
output "group_arn" {
  value = aws_iam_group.this.arn
}

output "group_name" {
  value = aws_iam_group.this.name
}

output "dev_assumed_role_id" {
  value = aws_iam_role.dev_assumed_role.id
}

output "dev_assumed_role_arn" {
  value = aws_iam_role.dev_assumed_role.arn
}

output "dev_assumed_role_name" {
  value = aws_iam_role.dev_assumed_role.name
}