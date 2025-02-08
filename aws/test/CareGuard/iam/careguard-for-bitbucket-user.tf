# this code creates an IAM user without console access whose only purpose is to have its Access keys to be used by Bitbucket Pipelines for deployment

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
  profile = var.cred_profile
  default_tags {
    tags = {
      Created     = var.creation_date
      CreatedBy   = var.created_by
      Owner       = var.owner
      #Application = var.application
      Environment = var.cred_profile
    }
  }
}

resource "aws_iam_user" "user" {
  name = var.username
  tags = {
    Name        = var.username
    Created     = var.creation_date
    CreatedBy   = var.created_by
    Owner       = var.owner
    #Application = var.application
    IAC_Tool    = "Terraform"
    Incident    = "N/A"
  }
}

 # Managed IAM User Policy
resource "aws_iam_policy" "ecr_ro" {
  description = "ECR Read Only Policy"
  name        = "ECR_ReadOnly_Policy"

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
  tags = {
    Name        = var.username
    Created     = var.creation_date
    CreatedBy   = var.created_by
    Owner       = var.owner
    #Application = var.application
    IAC_Tool    = "Terraform"
    Incident    = "N/A"
  }
}

resource "aws_iam_user_policy_attachment" "ecr_ro_attach" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.ecr_ro.arn
}

# Managed IAM User Policy
resource "aws_iam_policy" "ecs_wr" {
  description = "ECS Write Policy"
  name        = "ECS_Write_Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect: "Allow",
            Action: "ecs:UpdateService",
            Resource: join("", ["arn:aws:ecs:*:", var.aws_account, ":service/*/*"])
        },
        {
            Effect: "Allow",
            Action: "ecs:RegisterTaskDefinition",
            Resource: "*"
        }
    ]
  })
  tags = {
    Name        = var.username
    Created     = var.creation_date
    CreatedBy   = var.created_by
    Owner       = var.owner
    #Application = var.application
    IAC_Tool    = "Terraform"
    Incident    = "N/A"
  }
}

resource "aws_iam_user_policy_attachment" "ecs_wr_attach" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.ecs_wr.arn
}

# Inline IAM User Policy
resource "aws_iam_user_policy" "ecr_wr" {
  name        = "CG3_ECR_Write_Policy"
  user        = aws_iam_user.user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect: "Allow",
            Action: [
                "ecr:PutImageTagMutability",
                "ecr:StartImageScan",
                "ecr:PutImageScanningConfiguration",
                "ecr:CompleteLayerUpload",
                "ecr:BatchDeleteImage",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:ReplicateImage",
                "ecr:PutImage"
            ],
            Resource: join("", ["arn:aws:ecr:us-east-1:", var.aws_account, ":repository/cg3-backend"])
        }
    ]
  })
}

# Inline IAM User Policy
resource "aws_iam_user_policy" "s3_wr" {
  name        = "CG3_S3_Write_Policy"
  user        = aws_iam_user.user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect: "Allow",
            Action: [
                "s3:PutObject",
                "s3:ListBucket"
            ],
            Resource: [
                "arn:aws:s3:::careguard-frontend-test-bucket",
                "arn:aws:s3:::careguard-frontend-test-bucket/*"
            ]
        }
    ]
  })
}

# Inline IAM User Policy
resource "aws_iam_user_policy" "cloudfront" {
  name        = "CG3_CloudFront_Policy"
  user        = aws_iam_user.user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect: "Allow",
            Action: "cloudfront:CreateInvalidation",
            Resource: join("", ["arn:aws:cloudfront::", var.aws_account, ":distribution/", var.cloudfront_dist_id])
        }
    ]
  })
}

# Inline IAM User Policy
resource "aws_iam_user_policy" "lambda_wr" {
  name        = "CG3_Lambda_Write_Policy"
  user        = aws_iam_user.user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect: "Allow",
            Action: "lambda:UpdateFunctionCode",
            Resource: [
                join("", ["arn:aws:lambda:us-east-1:", var.aws_account, ":function:careguard-user-migration-test"]),
                join("", ["arn:aws:lambda:us-east-1:", var.aws_account, ":function:careguard-pretoken-generator-test"])
            ]
        }
    ]
  })
}

# Inline IAM User Policy
resource "aws_iam_user_policy" "pass_role" {
  name        = "CG3_ECS_Pass_Role_Policy"
  user        = aws_iam_user.user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Sid: "PolicyStatementToAllowUserToPassOneSpecificRole",
            Effect: "Allow",
            Action: [
                "iam:PassRole"
            ],
            Resource: [
                join ("", ["arn:aws:iam::", var.aws_account, ":role/", var.ecs_task_role_name]),
                join ("", ["arn:aws:iam::", var.aws_account, ":role/", var.ecs_task_exec_role_name])
            ]
        }
    ]
  })
}

# Inline IAM User Policy
resource "aws_iam_user_policy" "cognito_wr" {
  name        = "CG3_Cognito_Write_Policy"
  user        = aws_iam_user.user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Sid: "CognitoAccess",
            Effect: "Allow",
            Action: [
                "cognito-idp:AdminEnableUser",
                "cognito-idp:AdminCreateUser",
                "cognito-idp:AdminDisableUser",
                "cognito-idp:AdminDeleteUser" 
            ],
            Resource: "*"
        }
    ]
  })
}

output "new_user_arn" {
  value = aws_iam_user.user.arn
}
