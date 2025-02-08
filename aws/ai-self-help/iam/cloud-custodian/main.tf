# data "aws_caller_identity" "this_account_id" {}

# locals {
#     this_account_id    = data.aws_caller_identity.this_account_id.account_id
# }

# Customer Managed Policy
resource "aws_iam_policy" "cc_policy" {
  name        = var.iam_policy_name
  description = "Permissions required for various Cloud Custodian actions"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "CloudCustodian",
        Effect : "Allow",
        Action : [
          "lambda:CreateFunction",
          "s3:ListAccessPointsForObjectLambda",
          "lambda:TagResource",
          "states:DescribeStateMachine",
          "lambda:GetFunctionConfiguration",
          "lambda:GetProvisionedConcurrencyConfig",
          "lambda:ListLayers",
          "lambda:ListCodeSigningConfigs",
          "lambda:GetAlias",
          "iam:ListRolePolicies",
          "cloudformation:ListStackResources",
          "iam:GetRole",
          "events:DescribeRule",
          "s3:PutAccountPublicAccessBlock",
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
          "lambda:UpdateFunctionCode",
          "lambda:GetFunctionConcurrency",
          "cloudwatch:*",
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
          "lambda:UntagResource",
          "cloudwatch:ListMetrics",
          "tag:TagResources",
          "lambda:ListTags",
          "s3:PutBucketTagging",
          "xray:GetTraceSummaries",
          "s3:GetMultiRegionAccessPointPolicyStatus",
          "s3:ListBucketMultipartUploads",
          "iam:ListRoles",
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
          "iam:ListAttachedRolePolicies",
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
          "acm:DescribeCertificate",
          "lambda:ListFunctionsByCodeSigningConfig",
          "s3:DescribeJob",
          "lambda:ListEventSourceMappings",
          "s3:GetAnalyticsConfiguration",
          "s3:GetObjectVersionForReplication",
          "s3:GetAccessPointForObjectLambda",
          "s3:GetAccessPoint",
          "lambda:ListVersionsByFunction",
          "lambda:GetLayerVersion",
          "cloudwatch:GetMetricData",
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
          "acm:ListCertificates",
          "s3:GetObjectTagging",
          "s3:GetMetricsConfiguration",
          "s3:GetBucketOwnershipControls",
          "s3:GetBucketPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetMultiRegionAccessPointPolicy",
          "logs:DescribeLogGroups",
          "s3:GetAccessPointPolicyStatusForObjectLambda",
          "s3:ListAccessPoints",
          "lambda:GetFunction",
          "s3:ListMultiRegionAccessPoints",
          "s3:GetBucketAcl",
          "s3:ListStorageLensConfigurations",
          "xray:BatchGetTraces",
          "events:PutTargets",
          "s3:GetObjectTorrent",
          "lambda:AddPermission",
          "lambda:GetFunctionEventInvokeConfig",
          "s3:GetBucketLocation",
          "s3:GetAccessPointPolicy",
          "lambda:GetPolicy",
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
          "directconnect:DescribeConnections",
          "fsx:DescribeFileSystems",
          "waf:ListWebACLs",
          "connect:ListInstances",
          "connect:DescribeInstance"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role" "role_assumed" {
  name        = var.iam_role_name
  description = var.iam_role_description

  # Trusted entities
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::${var.assuming_account}:role/sre-ec2-role"
        },
        "Action": "sts:AssumeRole",
        "Condition": {}
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cc-attach" {
  role       = aws_iam_role.role_assumed.name
  policy_arn = aws_iam_policy.cc_policy.arn
}

output "cloud_custodian_role_arn" {
  value = aws_iam_role.role_assumed.arn
}