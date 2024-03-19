terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.39"
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
    Name        = "BitBucket Pipelines"
    Created     = var.creation_date
    CreatedBy   = var.created_by
    Owner       = var.owner
    #Application = var.application
    IAC_Tool    = "Terraform"
    Incident    = "N/A"
  }
}

resource "aws_iam_user_policy" "ecr_ro" {
  name = "ECR_ReadOnly_Policy"
  user = aws_iam_user.user.name

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

resource "aws_iam_user_policy" "ecr_wr" {
  name = "BB_Pipelines_ECR_Write_Policy"
  user = aws_iam_user.user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:PutImageTagMutability",
          "ecr:StartImageScan",
          "ecr:PutImageScanningConfiguration",
          "ecr:CompleteLayerUpload",
          "ecr:BatchDeleteImage",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:ReplicateImage",
          "ecr:PutImage"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ecr:us-east-1:472510080448:repository/sre-team/imagebuilder",
        Sid = "EcrAccess"
      },
    ]
  })
}

output "new_user_arn" {
  value = aws_iam_user.user.arn
}

output "new_user_path" {
  value = aws_iam_user.user.path
}
