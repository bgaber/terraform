data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_iam_user" "service_account" {
  name = var.elite_passwd_rotation_service_account
}

resource "aws_iam_user_policy" "lambda_limited_access" {
  name = "LimitedLambdaAccess"
  user = aws_iam_user.service_account.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LimitedLambdaAccess",
            "Effect": "Allow",
            "Action": [
                "lambda:DisableReplication",
                "lambda:EnableReplication",
                "lambda:Invoke*",
                "lambda:ListTags",
                "lambda:TagResource",
                "lambda:UntagResource",
                "lambda:UpdateFunctionCode*"
            ],
            "Resource": "arn:aws:lambda:us-east-1:${local.account_id}:function:${var.lambda_function_name}"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "s3_limited_access" {
  name = "ResourceLimitedS3Access"
  user = aws_iam_user.service_account.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        "Resource": [
          "arn:aws:s3:::${var.s3_bucket_name}/*",
          "arn:aws:s3:::${var.s3_bucket_name}"
        ]
      }
    ]
}
EOF
}

resource "aws_iam_access_key" "elite_passwd_rotation_service_account" {
  user    = aws_iam_user.service_account.name
}

# Cloud Custodian Gitlab Pipeline Variables
resource "gitlab_project_variable" "aws_default_region" {
  project   = var.elite_passwd_rotation_gitlab_repo_id
  key       = "AWS_DEFAULT_REGION"
  value     = var.region
  masked    = false
  protected = false
}

resource "gitlab_project_variable" "aws_region" {
  project   = var.elite_passwd_rotation_gitlab_repo_id
  key       = "AWS_REGION"
  value     = var.region
  masked    = false
  protected = false
}

resource "gitlab_project_variable" "aws_access_key_id" {
  project   = var.elite_passwd_rotation_gitlab_repo_id
  key       = "AWS_ACCESS_KEY_ID"
  value     = aws_iam_access_key.elite_passwd_rotation_service_account.id
  masked    = false
  protected = false
}

resource "gitlab_project_variable" "aws_secret_access_key" {
  project   = var.elite_passwd_rotation_gitlab_repo_id
  key       = "AWS_SECRET_ACCESS_KEY"
  value     = aws_iam_access_key.elite_passwd_rotation_service_account.secret
  masked    = true
  protected = false
}

resource "gitlab_project_variable" "lambda_function_name" {
  project   = var.elite_passwd_rotation_gitlab_repo_id
  key       = "LAMBDA_FUNCTION_NAME"
  value     = var.lambda_function_name
  masked    = false
  protected = false
}

resource "gitlab_project_variable" "s3_bucket_name" {
  project   = var.elite_passwd_rotation_gitlab_repo_id
  key       = "S3_BUCKET"
  value     = var.s3_bucket_name
  masked    = false
  protected = false
}

resource "gitlab_project_variable" "s3_bucket_key" {
  project   = var.elite_passwd_rotation_gitlab_repo_id
  key       = "S3_KEY"
  value     = var.lambda_deployment_pkg
  masked    = false
  protected = false
}

# Outputs
output "service_account_id" {
  value = aws_iam_user.service_account.id
}

output "service_account_arn" {
  value = aws_iam_user.service_account.arn
}

output "service_account_name" {
  value = aws_iam_user.service_account.name
}

output "service_secret_id" {
  value = aws_iam_access_key.elite_passwd_rotation_service_account.id
}

output "service_secret_access_key" {
  value = aws_iam_access_key.elite_passwd_rotation_service_account.secret
  sensitive = true
}