terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "PkgFactory"
}

resource "aws_iam_role_policy" "cc_waf_policy" {
  name = "CloudCustodianWAFpolicy"
  role = aws_iam_role.role_assumed.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Action : "waf-regional:ListWebACLs",
        Resource : "*"
      },
    ]
  })
}

resource "aws_iam_role" "role_assumed" {
  name = "sre-ec2-role-assumed"
  tags = {
    Owner       = "Bryan Erwin"
    Application = "Cloud Custodian"
    Creator     = "Brian Gaber"
    Created     = "22 Jul 2022"
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Principal : {
          Service : "ec2.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      },
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
          AWS : "arn:aws:iam::472510080448:role/sre-ec2-role"
        },
        Action : "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_policy" "cc_policy" {
  name        = "cloud-custodian"
  description = "Permissions required for various Cloud Custodian actions"
  tags = {
    Owner       = "Bryan Erwin"
    Application = "Cloud Custodian"
    Creator     = "Brian Gaber"
    Created     = "22 Jul 2022"
  }

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "VisualEditor0",
        Effect : "Allow",
        Action : "iam:PassRole",
        Resource : "*",
        Condition : {
          StringEquals : {
            "iam:PassedToService" : "lambda.amazonaws.com"
          }
        }
      },
      {
        Sid : "VisualEditor1",
        Effect : "Allow",
        Action : [
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        Resource : "arn:aws:logs:*:*:log-group:/aws/lambda/*"
      },
      {
        Sid : "VisualEditor2",
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
          "iam:ListRolePolicies",
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
          "tag:TagResources"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "sqs_sre_policy" {
  name        = "sqs-sre-access-from-shared"
  description = "Permissions required for Cloud Custodian SQS actions"
  tags = {
    Owner       = "Bryan Erwin"
    Application = "Cloud Custodian"
    Creator     = "Brian Gaber"
    Created     = "22 Jul 2022"
  }

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
        Resource : "arn:aws:sqs:us-east-1:472510080448:cloud-custodian"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cc-attach" {
  role       = aws_iam_role.role_assumed.name
  policy_arn = aws_iam_policy.cc_policy.arn
}

resource "aws_iam_role_policy_attachment" "sqs-sre-attach" {
  role       = aws_iam_role.role_assumed.name
  policy_arn = aws_iam_policy.sqs_sre_policy.arn
}

resource "aws_iam_role_policy_attachment" "rds-full-access" {
  role       = aws_iam_role.role_assumed.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2-full-access" {
  role       = aws_iam_role.role_assumed.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.role_assumed.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchEventsReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "resource-group" {
  role       = aws_iam_role.role_assumed.name
  policy_arn = "arn:aws:iam::aws:policy/ResourceGroupsandTagEditorReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "code-build" {
  role       = aws_iam_role.role_assumed.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "elb-ro" {
  role       = aws_iam_role.role_assumed.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingReadOnly"
}