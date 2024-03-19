data "aws_caller_identity" "shared" {}

data "aws_caller_identity" "switch" {
  provider = aws.switch_role
}

locals {
    origin_account_id   = data.aws_caller_identity.shared.account_id
    switched_account_id = data.aws_caller_identity.switch.account_id
}

resource "aws_iam_user" "bitbucket_user" {
  name = var.iam_user_name
}

# Provides an IAM role inline policy.
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
}

resource "aws_iam_user_policy" "bitbucket_policy" {
  name   = "Terraform_Provider_Policy"
  user   = aws_iam_user.bitbucket_user.name
  policy = data.aws_iam_policy_document.origin_bitbucket_policy_doc.json
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
            "AWS": "arn:aws:iam::${local.origin_account_id}:root"
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

resource "aws_iam_role_policy_attachment" "dynamodb-admin-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
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