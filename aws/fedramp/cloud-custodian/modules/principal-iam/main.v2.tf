data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

# Group with common permissions for custodian and mailer
resource "aws_iam_group" "cloud_custodian" {
  name = "cloud-custodian"
}

resource "aws_iam_group_membership" "cloud_custodian" {
  name = "cloud-custodian-group-membership"

  users = [
    aws_iam_user.cc_mailer_service_account.name,
    aws_iam_user.cc_service_account.name,
  ]

  group = aws_iam_group.cloud_custodian.name
}

# Group with cross account IAM Assume Role permissions
resource "aws_iam_group" "cloud_custodian_cross_account" {
  name = "cloud-custodian-cross_account"
}

resource "aws_iam_group_membership" "cloud_custodian_cross_account" {
  name = "cloud-custodian-cross_account-group-membership"

  users = [
    aws_iam_user.cc_service_account.name,
  ]

  group = aws_iam_group.cloud_custodian_cross_account.name
}

# Cloud Custodian Mailer IAM Service Account
resource "aws_iam_user" "cc_mailer_service_account" {
  name = var.cc_mailer_service_account
}

resource "aws_iam_access_key" "cc_mailer_service_account" {
  user    = aws_iam_user.cc_mailer_service_account.name
}

# Cloud Custodian IAM Service Account
resource "aws_iam_user" "cc_service_account" {
  name = var.cc_service_account
}

resource "aws_iam_access_key" "cc_service_account" {
  user    = aws_iam_user.cc_service_account.name
}

resource "aws_iam_group_policy_attachment" "cc_mailer_lambda_full_access_attach" {
  group       = aws_iam_group.cloud_custodian.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

# Inline IAM Group Policy
resource "aws_iam_group_policy" "cc_mailer_gitlab_access" {
  name        = "GitLab_Runner_EventBridge_Access"
  group        = aws_iam_group.cloud_custodian.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
          "Sid": "GitLabRunnerEventBridgePerms",
          Effect: "Allow",
          Action: [
              "events:DescribeRule",
              "events:PutRule",
              "events:ListTargetsByRule",
              "events:PutTargets"
          ],
          Resource: "*"
        }
    ]
  })
}

# Inline IAM Group Policy
resource "aws_iam_group_policy" "cc_cross_account_assume_role_premissions" {
  name        = "cross-account-assume-role-permissions"
  group        = aws_iam_group.cloud_custodian_cross_account.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
          "Sid": "CrossAccountAssumeRolePerms",
          Effect: "Allow",
          Action: "sts:AssumeRole",
          "Resource": [
                "arn:aws:iam::438979369891:role/${var.cc_iam_role_name}",
                "arn:aws:iam::686255941416:role/${var.cc_iam_role_name}",
                "arn:aws:iam::311141548321:role/${var.cc_iam_role_name}",
                "arn:aws:iam::528757785295:role/${var.cc_iam_role_name}",
                "arn:aws:iam::054037137415:role/${var.cc_iam_role_name}",
                "arn:aws:iam::202533508444:role/${var.cc_iam_role_name}",
                "arn:aws:iam::816069130447:role/${var.cc_iam_role_name}",
                "arn:aws:iam::548813917035:role/${var.cc_iam_role_name}",
                "arn:aws:iam::445567083790:role/${var.cc_iam_role_name}",
                "arn:aws:iam::104299473261:role/${var.cc_iam_role_name}",
                "arn:aws:iam::980921753767:role/${var.cc_iam_role_name}",
                "arn:aws:iam::897722679597:role/${var.cc_iam_role_name}",
                "arn:aws:iam::195665324256:role/${var.cc_iam_role_name}"
            ]
        }
    ]
  })
}

# Cloud Custodian Mailer IAM Role
resource "aws_iam_role" "cc_mailer_role" {
  name = var.cc_mailer_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Principal : {
          Service : "lambda.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "cc_mailer_policy" {
  name        = var.cc_mailer_iam_policy_name
  description = var.cc_mailer_iam_policy_description

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "cloudwatch:GetMetricStatistics",
            "cloudwatch:PutMetricData"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogStream",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
            "logs:GetLogEvents",
            "logs:FilterLogEvents",
            "logs:CreateLogGroup",
            "logs:PutLogEvents"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
            "sqs:GetQueueUrl",
            "sqs:ListDeadLetterSourceQueues",
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes",
            "sqs:ListQueueTags"
        ],
        "Resource": "${var.sqs_arn}"
      },
      {
        "Effect": "Allow",
        "Action": [
            "sns:Publish"
        ],
        "Resource": "arn:aws:sns:us-east-1:${local.account_id}:cloud-custodian-mailer"
      },
      {
        "Effect": "Allow",
        "Action": [
            "ses:SendEmail",
            "ses:SendRawEmail"
        ],
        "Resource": "*",
        "Condition": {
            "ForAllValues:StringLike": {
                "ses:Recipients": [
                    "*@tecsys.com"
                ]
            }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cc_mailer_attach" {
  role       = aws_iam_role.cc_mailer_role.name
  policy_arn = aws_iam_policy.cc_mailer_policy.arn
}

# Cloud Custodian IAM Role
resource "aws_iam_role" "cc_role" {
  name = var.cc_iam_role_name

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
          AWS : "arn:aws:iam::${local.account_id}:user/${var.cc_service_account}"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "cc_policy" {
  name        = var.cc_iam_policy_name
  description = var.cc_iam_policy_description

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
        {
        Sid : "CloudCustodianAccess",
        Effect : "Allow",
        Action : [
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "s3:ListAccessPointsForObjectLambda",
          "lambda:TagResource",
          "states:DescribeStateMachine",
          "lambda:GetFunctionConfiguration",
          "lambda:GetProvisionedConcurrencyConfig",
          "lambda:ListLayers",
          "lambda:ListCodeSigningConfigs",
          "lambda:GetAlias",
          "cloudformation:ListStackResources",
          "iam:GetRole",
          "events:DescribeRule",
          "lambda:ListFunctions",
          "s3:GetBucketWebsite",
          "iam:GetPolicy",
          "lambda:GetEventSourceMapping",
          "lambda:ListAliases",
          "s3:GetMultiRegionAccessPoint",
          "s3:GetObjectLegalHold",
          "s3:GetBucketNotification",
          "lambda:GetFunctionCodeSigningConfig",
          "s3:DescribeMultiRegionAccessPointOperation",
          "s3:GetReplicationConfiguration",
          "events:TestEventPattern",
          "cloudwatch:*",
          "lambda:GetFunctionConcurrency",
          "ec2:DescribeSubnets",
          "iam:GetRolePolicy",
          "s3:GetStorageLensDashboard",
          "s3:GetLifecycleConfiguration",
          "tag:GetResources",
          "s3:GetInventoryConfiguration",
          "s3:GetBucketTagging",
          "s3:GetAccessPointPolicyForObjectLambda",
          "events:PutRule",
          "s3:ListBucket",
          "cloudwatch:ListMetrics",
          "lambda:UntagResource",
          "lambda:ListTags",
          "s3:PutBucketTagging",
          "xray:GetTraceSummaries",
          "s3:GetMultiRegionAccessPointPolicyStatus",
          "s3:ListBucketMultipartUploads",
          "s3:GetBucketVersioning",
          "s3:GetAccessPointConfigurationForObjectLambda",
          "ec2:DescribeSecurityGroups",
          "s3:GetStorageLensConfiguration",
          "s3:GetAccountPublicAccessBlock",
          "s3:ListAllMyBuckets",
          "ec2:DescribeVpcs",
          "kms:ListAliases",
          "s3:GetBucketCORS",
          "lambda:GetCodeSigningConfig",
          "s3:GetObjectVersion",
          "iam:GetPolicyVersion",
          "states:ListStateMachines",
          "s3:GetObjectVersionTagging",
          "logs:*",
          "s3:GetStorageLensConfigurationTagging",
          "s3:GetObjectAcl",
          "s3:GetBucketObjectLockConfiguration",
          "lambda:ListProvisionedConcurrencyConfigs",
          "s3:GetIntelligentTieringConfiguration",
          "events:ListRuleNamesByTarget",
          "s3:GetObjectVersionAcl",
          "events:ListRules",
          "lambda:ListLayerVersions",
          "events:ListTargetsByRule",
          "s3:GetBucketPolicyStatus",
          "s3:GetObjectRetention",
          "s3:GetJobTagging",
          "s3:ListJobs",
          "s3-object-lambda:*",
          "cloudformation:DescribeStacks",
          "s3:ListMultipartUploadParts",
          "events:DescribeEventBus",
          "s3:GetObject",
          "lambda:ListFunctionEventInvokeConfigs",
          "lambda:ListFunctionsByCodeSigningConfig",
          "s3:DescribeJob",
          "lambda:ListEventSourceMappings",
          "s3:GetAnalyticsConfiguration",
          "s3:GetObjectVersionForReplication",
          "s3:GetAccessPointForObjectLambda",
          "s3:GetAccessPoint",
          "cloudwatch:GetMetricData",
          "lambda:ListVersionsByFunction",
          "lambda:GetLayerVersion",
          "s3:GetBucketLogging",
          "s3:ListBucketVersions",
          "lambda:GetAccountSettings",
          "s3:GetAccelerateConfiguration",
          "lambda:GetLayerVersionPolicy",
          "s3:GetBucketPolicy",
          "s3:PutEncryptionConfiguration",
          "s3:GetEncryptionConfiguration",
          "s3:GetObjectVersionTorrent",
          "s3:GetBucketRequestPayment",
          "s3:GetAccessPointPolicyStatus",
          "s3:GetObjectTagging",
          "s3:GetMetricsConfiguration",
          "s3:GetBucketOwnershipControls",
          "s3:GetBucketPublicAccessBlock",
          "logs:DescribeLogGroups",
          "s3:GetMultiRegionAccessPointPolicy",
          "s3:GetAccessPointPolicyStatusForObjectLambda",
          "s3:ListAccessPoints",
          "lambda:GetFunction",
          "s3:ListMultiRegionAccessPoints",
          "s3:GetBucketAcl",
          "xray:BatchGetTraces",
          "s3:ListStorageLensConfigurations",
          "events:PutTargets",
          "s3:GetObjectTorrent",
          "lambda:AddPermission",
          "lambda:GetFunctionEventInvokeConfig",
          "s3:GetBucketLocation",
          "s3:GetAccessPointPolicy",
          "lambda:GetPolicy",
          "tag:TagResources",
          "cognito-idp:ListUserPools",
          "cognito-idp:DescribeUserPool",
          "cognito-idp:UntagResource",
          "cognito-idp:TagResource",
          "apigateway:GET",
          "apigateway:PATCH",
          "apigateway:PUT",
          "dynamodb:ListTables",
          "dynamodb:DescribeTable",
          "dynamodb:TagResource",
          "dynamodb:UntagResource",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:CreateTags",
          "elasticfilesystem:TagResource",
          "elasticfilesystem:UntagResource",
          "glue:GetJobs",
          "glue:TagResource",
          "glue:UntagResource",
          "kinesis:ListStreams",
          "kinesis:DescribeStream",
          "kinesis:AddTagsToStream",
          "kinesis:RemoveTagsFromStream",
          "mq:ListBrokers",
          "mq:DescribeBroker",
          "mq:CreateTags",
          "mq:DeleteTags",
          "ses:ListEmailIdentities",
          "ses:GetEmailIdentity",
          "ses:TagResource",
          "ses:UntagResource",
          "SNS:GetTopicAttributes",
          "SNS:TagResource",
          "SNS:UntagResource",
          "sqs:ListQueues",
          "sqs:TagQueue",
          "sqs:UntagQueue",
          "sqs:SendMessage",
          "directconnect:DescribeConnections",
          "fsx:DescribeFileSystems",
          "waf:ListWebACLs",
          "connect:ListInstances",
          "iam:UpdateAccessKey",
          "iam:DeleteLoginProfile",
          "iam:DeactivateMFADevice",
          "iam:RemoveUserFromGroup",
          "iam:GetUser",
          "iam:GenerateServiceLastAccessedDetails",
          "iam:GetServiceLastAccessedDetails",
          "iam:DeleteUser",
          "iam:DetachUserPolicy",
          "iam:DeleteAccessKey",
          "iam:DeleteUserPolicy",
          "ec2:Describe*",
          "rds:DescribeDB*",
          "elasticloadbalancing:Describe*",
          "autoscaling:Describe*",
          "codebuild:List*",
          "batch:Describe*",
          "iam:List*",
          "acm:List*",
          "acm:DescribeCertificate",
          "events:List*"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "cc_sqs_policy" {
  name        = var.sqs_iam_policy_name
  description = var.sqs_iam_policy_description

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "iam:ListAccountAliases",
        Resource : "*"
      },
      {
        Effect : "Allow",
        Action : "sqs:*",
        Resource : "${var.sqs_arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cc_attach" {
  role       = aws_iam_role.cc_role.name
  policy_arn = aws_iam_policy.cc_policy.arn
}

resource "aws_iam_role_policy_attachment" "sqs_attach" {
  role       = aws_iam_role.cc_role.name
  policy_arn = aws_iam_policy.cc_sqs_policy.arn
}

# Cloud Custodian Mailer Gitlab Pipeline Variables
# resource "gitlab_project_variable" "cc_mailer_aws_region" {
#   project   = var.cc_mailer_gitlab_repo_id
#   key       = "AWS_REGION"
#   value     = "us-east-1"
#   masked    = false
#   protected = false
# }

# resource "gitlab_project_variable" "aws_access_key_id" {
#   project   = var.cc_mailer_gitlab_repo_id
#   key       = "AWS_ACCESS_KEY_ID"
#   value     = aws_iam_access_key.cc_mailer_service_account.id
#   masked    = false
#   protected = false
# }

# resource "gitlab_project_variable" "cc_mailer_aws_secret_access_key" {
#   project   = var.cc_mailer_gitlab_repo_id
#   key       = "AWS_SECRET_ACCESS_KEY"
#   value     = aws_iam_access_key.cc_mailer_service_account.secret
#   masked    = true
#   protected = false
# }

# Cloud Custodian Gitlab Pipeline Variables
# resource "gitlab_project_variable" "cc_aws_default_region" {
#   project   = var.cc_gitlab_repo_id
#   key       = "AWS_DEFAULT_REGION"
#   value     = "us-east-1"
#   masked    = false
#   protected = false
# }

# resource "gitlab_project_variable" "cc_aws_access_key_id" {
#   project   = var.cc_gitlab_repo_id
#   key       = "AWS_ACCESS_KEY_ID"
#   value     = aws_iam_access_key.cc_service_account.id
#   masked    = false
#   protected = false
# }

# resource "gitlab_project_variable" "cc_aws_secret_access_key" {
#   project   = var.cc_gitlab_repo_id
#   key       = "AWS_SECRET_ACCESS_KEY"
#   value     = aws_iam_access_key.cc_service_account.secret
#   masked    = true
#   protected = false
# }

# Outputs
output "cc_mailer_service_account_id" {
  value = aws_iam_user.cc_mailer_service_account.id
}

output "cc_mailer_service_account_arn" {
  value = aws_iam_user.cc_mailer_service_account.arn
}

output "cc_mailer_service_account_name" {
  value = aws_iam_user.cc_mailer_service_account.name
}

output "cc_mailer_service_secret_id" {
  value = aws_iam_access_key.cc_mailer_service_account.id
}

output "cc_mailer_service_secret_access_key" {
  value = aws_iam_access_key.cc_mailer_service_account.secret
  sensitive = true
}

output "cc_mailer_role_id" {
  value = aws_iam_role.cc_mailer_role.id
}

output "cc_mailer_role_arn" {
  value = aws_iam_role.cc_mailer_role.arn
}

output "cc_mailer_role_name" {
  value = aws_iam_role.cc_mailer_role.name
}

output "cc_service_account_id" {
  value = aws_iam_user.cc_service_account.id
}

output "cc_service_account_arn" {
  value = aws_iam_user.cc_service_account.arn
}

output "cc_service_account_name" {
  value = aws_iam_user.cc_service_account.name
}

output "cc_service_secret_id" {
  value = aws_iam_access_key.cc_service_account.id
}

output "cc_service_secret_access_key" {
  value = aws_iam_access_key.cc_service_account.secret
  sensitive = true
}

output "cc_role_id" {
  value = aws_iam_role.cc_role.id
}

output "cc_role_arn" {
  value = aws_iam_role.cc_role.arn
}

output "cc_role_name" {
  value = aws_iam_role.cc_role.name
}