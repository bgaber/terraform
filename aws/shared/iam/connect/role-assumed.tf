# This code creates the IAM policy in Shared and the assumed role in Prod
# No groups or users are created
# After "terraform apply" manual association of policy using console is required

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.login_cred_profile
  default_tags {
    tags = {
      Created     = "12 Jul 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Connect"
    }
  }
}

provider "aws" {
  alias   = "switch_role"
  region  = var.region
  profile = var.switch_role_cred_profile

  default_tags {
    tags = {
      Created     = "12 Jul 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rama Pulivarthy"
      Application = "Connect"
    }
  }
}

data "aws_caller_identity" "shared" {}

data "aws_caller_identity" "switch" {
  provider = aws.switch_role
}

locals {
    shared_account_id    = data.aws_caller_identity.shared.account_id
    switched_account_id  = data.aws_caller_identity.switch.account_id
}

resource "aws_iam_policy" "assume_role_policy" {
  name = var.assume_role_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "AssumeConnectRole",
        Effect : "Allow",
        Resource : "arn:aws:iam::${local.switched_account_id}:role/${var.assumed_role}"
        Action : "sts:AssumeRole"
      },
    ]
  })
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
            "AWS": "arn:aws:iam::${local.shared_account_id}:root"
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

# Provides an IAM role inline policy.
resource "aws_iam_role_policy" "alb_ro_policy" {
  provider = aws.switch_role
  name     = "ApiGatewayReadOnly"
  role     = aws_iam_role.assumed_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ApiGatewayReadOnly",
        Action   = "apigateway:get*",
        Effect   = "Allow"
        Resource = "arn:aws:apigateway:*::/*"
      }
    ]
  })
}

# Provides an IAM role inline policy.
resource "aws_iam_role_policy" "ecr_ro_policy" {
  provider = aws.switch_role
  name     = "ECR_ReadOnly_Policy"
  role     = aws_iam_role.assumed_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetRegistryPolicy",
          "ecr:DescribeImageScanFindings",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeRegistry",
          "ecr:DescribePullThroughCacheRules",
          "ecr:DescribeImageReplicationStatus",
          "ecr:GetAuthorizationToken",
          "ecr:ListTagsForResource",
          "ecr:ListImages",
          "ecr:BatchGetRepositoryScanningConfiguration",
          "ecr:GetRegistryScanningConfiguration",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetRepositoryPolicy",
          "ecr:GetLifecyclePolicy"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Provides an IAM role inline policy.
resource "aws_iam_role_policy" "ecs_ro_policy" {
  provider = aws.switch_role
  name     = "ECS_ReadOnly_Policy"
  role     = aws_iam_role.assumed_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VisualEditor0",
        Action = [
          "ecs:GetTaskProtection",
          "ecs:DescribeCapacityProviders",
          "ecs:ListTagsForResource",
          "ecs:ListAttributes",
          "ecs:DescribeServices",
          "ecs:DescribeTaskSets",
          "ecs:ListContainerInstances",
          "ecs:DescribeContainerInstances",
          "ecs:DescribeTasks",
          "ecs:DescribeClusters"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:ecs:*:${local.switched_account_id}:service/*/*",
          "arn:aws:ecs:*:${local.switched_account_id}:container-instance/*/*",
          "arn:aws:ecs:*:${local.switched_account_id}:task-definition/*:*",
          "arn:aws:ecs:*:${local.switched_account_id}:task/*/*",
          "arn:aws:ecs:*:${local.switched_account_id}:capacity-provider/*",
          "arn:aws:ecs:*:${local.switched_account_id}:task-set/*/*/*",
          "arn:aws:ecs:*:${local.switched_account_id}:cluster/*"
        ]
      },
      {
        Sid    = "VisualEditor1",
        Action = [
          "ecs:ListServices",
          "ecs:ListServicesByNamespace",
          "ecs:ListAccountSettings",
          "ecs:ListTasks",
          "ecs:ListTaskDefinitionFamilies",
          "ecs:ListTaskDefinitions",
          "ecs:DescribeTaskDefinition",
          "ecs:ListClusters",
          "servicediscovery:ListNamespaces",
          "application-autoscaling:DescribeScalableTargets",
          "application-autoscaling:DescribeScalingPolicies",
          "application-autoscaling:DescribeScalingActivities",
          "cloudwatch:DescribeAlarms"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Provides an IAM role inline policy.
resource "aws_iam_role_policy" "lex_ro_policy" {
  provider = aws.switch_role
  name     = "LexRecognizeText"
  role     = aws_iam_role.assumed_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "VisualEditor0",
        Action   = "lex:RecognizeText",
        Effect   = "Allow"
        Resource = "arn:aws:lex:us-east-1:${local.switched_account_id}:bot-alias/*/TSTALIASID"
      }
    ]
  })
}


# resource "aws_iam_policy" "amplify_ro_policy" {
#   provider    = aws.switch_role
#   name        = "AmplifyReadOnlyAccess"
#   description = "Customer Managed Amplify read only policy"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "amplify:Get*",
#           "amplify:List*",
#           "amplifybackend:Get*",
#           "amplifybackend:List*",
#           "amplifyuibuilder:Get*",
#           "amplifyuibuilder:List*"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "amplify-ro-access" {
#   provider   = aws.switch_role
#   role       = aws_iam_role.assumed_role.name
#   policy_arn = aws_iam_policy.amplify_ro_policy.arn
# }

resource "aws_iam_role_policy_attachment" "cognito-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
}

resource "aws_iam_role_policy_attachment" "lambda-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "dynamodb-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "kendra-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKendraReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lex-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonLexReadOnly"
}

resource "aws_iam_role_policy_attachment" "elb-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingReadOnly"
}

resource "aws_iam_role_policy_attachment" "amazon-connect-full-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonConnect_FullAccess"
}

# resource "aws_iam_role_policy_attachment" "amazon-connect-ro-access" {
#   provider   = aws.switch_role
#   role       = aws_iam_role.assumed_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonConnectReadOnlyAccess"
# }

output "assumed_role_id" {
  value = aws_iam_role.assumed_role.id
}

output "assumed_role_arn" {
  value = aws_iam_role.assumed_role.arn
}

output "assumed_role_name" {
  value = aws_iam_role.assumed_role.name
}