data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

# IAM Service Account
resource "aws_iam_user" "service_account" {
  name = var.service_account
}

resource "aws_iam_user_policy_attachment" "s3_full_access_attach" {
  user       = aws_iam_user.service_account.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Inline Parameter Store User Policy
resource "aws_iam_user_policy" "parameter_store_limited_access" {
  name = "LimitedParameterStoreAccess"
  user = aws_iam_user.service_account.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LimitedParameterStoreAccess1",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter",
                "ssm:PutParameter",
                "ssm:ListTagsForResource",
                "ssm:GetParameters"
            ],
            "Resource": "arn:aws:ssm:us-east-1:${local.account_id}:parameter/*"
        },
        {
            "Sid": "LimitedParameterStoreAccess2",
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameters"
            ],
            "Resource": "arn:aws:ssm:us-east-1:${local.account_id}:*"
        }
    ]
}
EOF
}

# Inline IAM User Policy
resource "aws_iam_user_policy" "iam_limited_access" {
  name     = "LimitedIAMAccess"
  user     = aws_iam_user.service_account.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "LimitedIAMAccess",
        Action   = [
          "iam:CreateRole",
          "iam:CreatePolicy",
          "iam:TagRole",
          "iam:TagPolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:GetUser",
          "iam:GetUserPolicy",
          "iam:ListPolicyVersions",
          "iam:ListAccessKeys",
          "iam:ListGroupsForUser",
          "iam:DeletePolicy",
          "iam:DeleteAccessKey",
          "iam:DeleteUserPolicy",
          "iam:DeleteUser"
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

data "aws_ssm_parameter" "datadog_api" {
  name = "DATADOG_API_KEY"
}

data "aws_ssm_parameter" "datadog_app" {
  name = "DATADOG_APP_KEY"
}

# To search for a project by ID, pass in the ID value
# OR
# Retrieve details of the noc group group's full path
data "gitlab_group" "noc" {
  group_id = 2062
  #full_path = "ops/noc"
}

resource "gitlab_project" "new_project" {
  name             = var.gitlab_repo_name
  description      = var.gitlab_repo_description
  path             = var.gitlab_repo_path
  visibility_level = "internal"

  namespace_id = data.gitlab_group.noc.id
}

# Gitlab Pipeline Variables
resource "gitlab_project_variable" "aws_default_region" {
  project   = gitlab_project.new_project.id
  key       = "AWS_DEFAULT_REGION"
  value     = "us-east-1"
  masked    = false
  protected = false
}

resource "gitlab_project_variable" "aws_access_key_id" {
  project   = gitlab_project.new_project.id
  key       = "AWS_ACCESS_KEY_ID"
  value     = aws_iam_access_key.service_account.id
  masked    = false
  protected = false
}

resource "gitlab_project_variable" "aws_secret_access_key" {
  project   = gitlab_project.new_project.id
  key       = "AWS_SECRET_ACCESS_KEY"
  value     = aws_iam_access_key.service_account.secret
  masked    = true
  protected = false
}

resource "gitlab_project_variable" "dd_api_key" {
  project   = gitlab_project.new_project.id
  key       = "DD_API_KEY"
  value     = data.aws_ssm_parameter.datadog_api.value
  masked    = true
  protected = false
}

resource "gitlab_project_variable" "dd_app_key" {
  project   = gitlab_project.new_project.id
  key       = "DD_APP_KEY"
  value     = data.aws_ssm_parameter.datadog_app.value
  masked    = true
  protected = false
}

output "gitlab_project_id" {
  value = gitlab_project.new_project.id
}

output "gitlab_project_web_url" {
  value = gitlab_project.new_project.web_url
}

output "gitlab_project_http_url_to_repo" {
  value = gitlab_project.new_project.http_url_to_repo
}

output "service_secret_id" {
  value = aws_iam_access_key.service_account.id
}

output "service_secret_access_key" {
  value = aws_iam_access_key.service_account.secret
  sensitive = true
}