# IAM Service Account
resource "aws_iam_user" "service_account" {
  name = var.service_account
}

resource "aws_iam_user_policy_attachment" "s3_full_access_attach" {
  user       = aws_iam_user.service_account.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user_policy_attachment" "athena_full_access_attach" {
  user       = aws_iam_user.service_account.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
}

resource "aws_iam_user_policy_attachment" "eb_sched_full_access_attach" {
  user       = aws_iam_user.service_account.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeSchedulerFullAccess"
}

resource "aws_iam_user_policy_attachment" "lambda_full_access_attach" {
  user       = aws_iam_user.service_account.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_user_policy_attachment" "sns_full_access_attach" {
  user       = aws_iam_user.service_account.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

resource "aws_iam_user_policy_attachment" "sms_read_access_attach" {
  user       = aws_iam_user.service_account.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

# Inline IAM User Policy
resource "aws_iam_user_policy" "glue_full_access_policy" {
  name     = "GlueFullAccess"
  user     = aws_iam_user.service_account.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "GlueFullAccess",
        Action   = "glue:*",
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Inline IAM User Policy
resource "aws_iam_user_policy" "iam_create_access_policy" {
  name     = "IAMCreateAccess"
  user     = aws_iam_user.service_account.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "IAMCreateAccess",
        Action   = [
          "iam:CreateRole",
          "iam:TagRole",
          "iam:CreatePolicy",
          "iam:TagPolicy",
          "iam:AttachRolePolicy"
        ],
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_access_key" "service_account" {
  user    = aws_iam_user.service_account.name
}

# Create a project for a given user (requires admin access)
data "gitlab_user" "briang" {
  username = "briang"
}

resource "gitlab_project" "briang_new_project" {
  name             = var.gitlab_repo_name
  description      = var.gitlab_repo_description
  path             = var.gitlab_repo_path
  visibility_level = "internal"

  # namespace_id = data.gitlab_user.briang.namespace_id # Defaults to your user.
}

# Gitlab Pipeline Variables
resource "gitlab_project_variable" "python_runtime" {
  project   = gitlab_project.briang_new_project.id
  key       = "PYTHON_RUNTIME"
  value     = "python3.12"
  masked    = false
  protected = false
}

resource "gitlab_project_variable" "aws_default_region" {
  project   = gitlab_project.briang_new_project.id
  key       = "AWS_DEFAULT_REGION"
  value     = "us-east-1"
  masked    = false
  protected = false
}

resource "gitlab_project_variable" "aws_access_key_id" {
  project   = gitlab_project.briang_new_project.id
  key       = "AWS_ACCESS_KEY_ID"
  value     = aws_iam_access_key.service_account.id
  masked    = false
  protected = false
}

resource "gitlab_project_variable" "aws_secret_access_key" {
  project   = gitlab_project.briang_new_project.id
  key       = "AWS_SECRET_ACCESS_KEY"
  value     = aws_iam_access_key.service_account.secret
  masked    = true
  protected = false
}

output "gitlab_project_id" {
  value = gitlab_project.briang_new_project.id
}

output "gitlab_project_web_url" {
  value = gitlab_project.briang_new_project.web_url
}

output "gitlab_project_http_url_to_repo" {
  value = gitlab_project.briang_new_project.http_url_to_repo
}

output "service_secret_id" {
  value = aws_iam_access_key.service_account.id
}

output "service_secret_access_key" {
  value = aws_iam_access_key.service_account.secret
  sensitive = true
}