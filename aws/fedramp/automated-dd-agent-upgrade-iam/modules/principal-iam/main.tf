data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

# Group with common permissions
resource "aws_iam_group" "datadog_agent_upgrade" {
  name = "datadog-agent-upgrade"
}

resource "aws_iam_group_membership" "datadog_agent_upgrade" {
  name = "datadog-agent-upgrade-group-membership"

  users = [
    aws_iam_user.ddau_service_account.name,
  ]

  group = aws_iam_group.datadog_agent_upgrade.name
}

# Automated Datadog Agent Upgrade IAM Service Account
resource "aws_iam_user" "ddau_service_account" {
  name = var.ddau_service_account
}

resource "aws_iam_access_key" "ddau_service_account" {
  user    = aws_iam_user.ddau_service_account.name
}

# Inline IAM Group Policy
# Cross account assume role permissions
resource "aws_iam_group_policy" "cross_account_assume_role_premissions" {
  name        = "cross-account-assume-role-permissions"
  group        = aws_iam_group.datadog_agent_upgrade.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
          "Sid": "CrossAccountAssumeRolePerms",
          Effect: "Allow",
          Action: "sts:AssumeRole",
          Resource: [
            for acct in var.target_aws_accounts :
            "arn:aws:iam::${acct}:role/${var.ddau_iam_role_name}"
          ]
        }
    ]
  })
}

# Inline IAM Group Policy
 # Permissions required for Terraform when run by Gitlab Runner to provision AWS resources
resource "aws_iam_group_policy" "ddau_mailer_gitlab_access" {
  name        = "GitLab_Runner_Terraform_Access"
  group        = aws_iam_group.datadog_agent_upgrade.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid": "GitLabRunnerS3Perms",
        Effect: "Allow",
        Action: [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:PutBucketPolicy",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutBucketTagging",
          "s3:GetBucket*",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject",
          "s3:GetAccelerateConfiguration",
          "s3:GetLifecycleConfiguration",
          "s3:GetReplicationConfiguration",
          "s3:GetEncryptionConfiguration",
          "s3:GetObjectTagging"
        ],
        "Resource": [
          "arn:aws:s3:::*",
          "arn:aws:s3:::*/*"
        ]
      },
      {
        "Sid": "GlueResources",
        "Effect": "Allow",
        "Action": [
          "glue:CreateDatabase",
          "glue:DeleteDatabase",
          "glue:GetDatabase",
          "glue:CreateTable",
          "glue:DeleteTable",
          "glue:GetTable",
          "glue:GetTags",
          "glue:UpdateTable"
        ],
        "Resource": "*"
      },
      {
        "Sid": "IAMRolesAndPolicies",
        "Effect": "Allow",
        "Action": [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:PassRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListPolicyVersions",
          "iam:CreatePolicyVersion",
          "iam:DeletePolicyVersion",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies"
        ],
        "Resource": "*"
      },
      {
        "Sid": "LambdaResources",
        "Effect": "Allow",
        "Action": [
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:DeleteFunction",
          "lambda:GetFunction",
          "lambda:GetLayerVersion",
          "lambda:ListVersionsByFunction",
          "lambda:GetFunctionCodeSigningConfig"
        ],
        "Resource": "*"
      },
      {
        "Sid": "SchedulerPermissions",
        "Effect": "Allow",
        "Action": [
          "scheduler:CreateSchedule",
          "scheduler:UpdateSchedule",
          "scheduler:DeleteSchedule",
          "scheduler:GetSchedule",
          "scheduler:ListSchedules"
        ],
        "Resource": "*"
      },
      {
        "Sid": "CloudWatchLogs",
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DeleteLogGroup"
        ],
        "Resource": "*"
      },
      {
        "Sid": "SSMDocumentManagement",
        "Effect": "Allow",
        "Action": [
          "ssm:CreateDocument",
          "ssm:DeleteDocument",
          "ssm:DescribeDocument",
          "ssm:ListDocuments",
          "ssm:UpdateDocument",
          "ssm:UpdateDocumentDefaultVersion",
          "ssm:GetDocument",
          "ssm:DescribeDocumentPermission"
        ],
        "Resource": "*"
      },
      {
        "Sid": "SSMAssociationManagement",
        "Effect": "Allow",
        "Action": [
          "ssm:CreateAssociation",
          "ssm:DeleteAssociation",
          "ssm:DescribeAssociation",
          "ssm:ListAssociations",
          "ssm:UpdateAssociation",
          "ssm:GetAssociation"
        ],
        "Resource": "*"
      },
      {
        "Sid": "SSMParameterStore",
        "Effect": "Allow",
        "Action": [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:DescribeParameters",
          "ssm:ListTagsForResource"
        ],
        "Resource": "*"
      },
      {
        "Sid": "SNSManagement",
        "Effect": "Allow",
        "Action": [
          "sns:CreateTopic",
          "sns:DeleteTopic",
          "sns:GetTopicAttributes",
          "sns:SetTopicAttributes",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sns:ListTagsForResource",
          "sns:GetSubscriptionAttributes"
        ],
        "Resource": "*"
      }
    ]
  })
}

# Automated Datadog Agent Upgrade Gitlab Pipeline Variables
# resource "gitlab_project_variable" "ddau_aws_default_region" {
#   project   = var.ddau_gitlab_repo_id
#   key       = "AWS_DEFAULT_REGION"
#   value     = "us-east-1"
#   masked    = false
#   protected = false
# }

# resource "gitlab_project_variable" "ddau_aws_access_key_id" {
#   project   = var.ddau_gitlab_repo_id
#   key       = "AWS_ACCESS_KEY_ID"
#   value     = aws_iam_access_key.ddau_service_account.id
#   masked    = false
#   protected = false
# }

# resource "gitlab_project_variable" "ddau_aws_secret_access_key" {
#   project   = var.ddau_gitlab_repo_id
#   key       = "AWS_SECRET_ACCESS_KEY"
#   value     = aws_iam_access_key.ddau_service_account.secret
#   masked    = true
#   protected = false
# }

# Outputs
output "ddau_service_account_id" {
  value = aws_iam_user.ddau_service_account.id
}

output "ddau_service_account_arn" {
  value = aws_iam_user.ddau_service_account.arn
}

output "ddau_service_account_name" {
  value = aws_iam_user.ddau_service_account.name
}

output "ddau_service_secret_id" {
  value = aws_iam_access_key.ddau_service_account.id
}

output "ddau_service_secret_access_key" {
  value = aws_iam_access_key.ddau_service_account.secret
  sensitive = true
}
