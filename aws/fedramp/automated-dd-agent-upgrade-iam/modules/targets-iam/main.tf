data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

# Automated Datadog Agent Upgrade IAM Role
resource "aws_iam_role" "ddau_role" {
  name = var.ddau_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Principal : {
          Service : "lambda.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      },
      {
        Effect : "Allow",
        Principal : {
          AWS : var.ddau_trusted_user_arn
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

 # Permissions required for Terraform when run by Gitlab to provision AWS resources
resource "aws_iam_policy" "ddau_policy" {
  name        = var.ddau_iam_policy_name
  description = var.ddau_iam_policy_description

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "AllowCreateSSMAssociation",
        Effect : "Allow",
        Action : [
          "ssm:CreateAssociation",
          "ssm:UpdateAssociation",
          "ssm:DescribeAssociation",
          "ssm:GetParameter",
          "ssm:ListTagsForResource",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListRolePolicies",
          "iam:GetRole",
          "iam:ListAttachedRolePolicies"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ddau_attach" {
  role       = aws_iam_role.ddau_role.name
  policy_arn = aws_iam_policy.ddau_policy.arn
}

# Outputs
output "ddau_role_id" {
  value = aws_iam_role.ddau_role.id
}

output "ddau_role_arn" {
  value = aws_iam_role.ddau_role.arn
}

output "ddau_role_name" {
  value = aws_iam_role.ddau_role.name
}