data "aws_caller_identity" "shared" {}

data "aws_caller_identity" "switch" {
  provider = aws.switch_role
}

locals {
    origin_account_id   = data.aws_caller_identity.shared.account_id
    switched_account_id = data.aws_caller_identity.switch.account_id
}

# Provides an IAM user
resource "aws_iam_user" "bitbucket_user" {
  name = var.iam_user_name
}

# Provides an IAM policy attached inline to a user
resource "aws_iam_user_policy" "assume_role_policy" {
  name = var.assume_role_policy_name
  user = aws_iam_user.bitbucket_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "AssumeTerraformBitbucketRole",
        Effect : "Allow",
        Resource : "arn:aws:iam::${local.switched_account_id}:role/${var.assumed_role}"
        Action : "sts:AssumeRole"
      },
    ]
  })
}

# Generates an IAM policy document in JSON format for use with resources that expect policy documents
data "aws_iam_policy_document" "origin_bitbucket_policy_doc" {
  statement {
    sid       = "TerraformProviderPolicy1"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::terraform-backend-for-cc"]
  }
  statement {
    sid       = "TerraformProviderPolicy2"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::terraform-backend-for-cc/*"]
  }
  statement {
    sid       = "TerraformProviderPolicy3"
    effect    = "Allow"
    actions   = ["dynamodb:DescribeTable", "dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = ["arn:aws:dynamodb:*:*:table/terraform-backend"]
  }
}

# Provides an IAM policy attached to a user.
resource "aws_iam_user_policy" "bitbucket_policy" {
  name   = "Terraform_Provider_Policy"
  user   = aws_iam_user.bitbucket_user.name
  policy = data.aws_iam_policy_document.origin_bitbucket_policy_doc.json
}

# Add Trusted entities to Assumed Role
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
            "AWS": "arn:aws:iam::${local.origin_account_id}:root"
        },
        "Action": "sts:AssumeRole",
      }
    ]
  })
}

# Add CloudWatch Full Access to Assumed Role
resource "aws_iam_role_policy_attachment" "cloudwatch-full-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

# Add Lambda Full Access to Assumed Role
resource "aws_iam_role_policy_attachment" "lambda-full-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

# Add IAM Full Access to Assumed Role
# resource "aws_iam_role_policy_attachment" "iam-full-access" {
#   provider   = aws.switch_role
#   role       = aws_iam_role.assumed_role.name
#   policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
# }

resource "aws_iam_role_policy" "inline_limited_iam_full_policy" {
  provider = aws.switch_role
  name     = "LimitedIAMWriteAccess"
  role     = aws_iam_role.assumed_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
          Sid: "LimitedIAMWriteAccess",
          Effect: "Allow",
          Action: [
            "iam:GetRole",
            "iam:GetRolePolicy",
            "iam:GetPolicy",
            "iam:GetPolicyVersion",
            "iam:CreateRole",
            "iam:CreatePolicy",
            "iam:CreatePolicyVersion",
            "iam:DeleteRole",
            "iam:DeletePolicy",
            "iam:DeletePolicyVersion",
            "iam:UpdateRole",
            "iam:AttachRolePolicy",
            "iam:DetachRolePolicy",
            "iam:PutRolePolicy",
            "iam:TagRole",
            "iam:TagPolicy",
            "iam:UntagRole",
            "iam:UntagPolicy"
          ],
          Resource: "*"
        }
    ]
  })
}

# Add S3 Read Only Access to Assumed Role
# resource "aws_iam_role_policy_attachment" "s3-readonly-access" {
#   provider   = aws.switch_role
#   role       = aws_iam_role.assumed_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
# }

resource "aws_iam_role_policy" "inline_limited_s3_ro_policy" {
  provider = aws.switch_role
  name     = "LimitedS3ReadOnlyAccess"
  role     = aws_iam_role.assumed_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
          Sid: "LimitedS3ReadOnlyAccess",
          Effect: "Allow",
          Action: [
            "s3:Get*",
            "s3:List*",
            "s3:Describe*",
            "s3-object-lambda:Get*",
            "s3-object-lambda:List*"
          ],
          Resource: [
            "arn:aws:s3:::connect-ai-selfhelp-bucket",
            "arn:aws:s3:::connect-ai-selfhelp-bucket/*",
            "arn:aws:s3:::connect-dr-iac-bucket",
            "arn:aws:s3:::connect-dr-iac-bucket/*"
          ]
        }
    ]
  })
}

output "aws_iam_user_arn" {
  value = aws_iam_user.bitbucket_user.arn
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