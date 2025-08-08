data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
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
          AWS : var.cc_trusted_user_arn
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

resource "aws_iam_role_policy_attachment" "cc_attach" {
  role       = aws_iam_role.cc_role.name
  policy_arn = aws_iam_policy.cc_policy.arn
}

# Outputs
output "cc_role_id" {
  value = aws_iam_role.cc_role.id
}

output "cc_role_arn" {
  value = aws_iam_role.cc_role.arn
}

output "cc_role_name" {
  value = aws_iam_role.cc_role.name
}