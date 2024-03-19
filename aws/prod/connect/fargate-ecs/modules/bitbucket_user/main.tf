data "aws_caller_identity" "prod" {}

locals {
    account_id = data.aws_caller_identity.prod.account_id
    dr_ecr_arn = replace(var.ecr_arn, var.prod_region, var.dr_region)
}

resource "aws_iam_user" "bitbucket_user" {
  name = var.iam_user_name
}

resource "aws_iam_user_policy" "ecr_write_access" {
  name = "Connect_ECR_Write_Policy"
  user = aws_iam_user.bitbucket_user.name

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
        Resource = [var.ecr_arn, local.dr_ecr_arn]
        Sid = "EcrAccessToSpecificECR"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "ecr_read_access_attach" {
  user       = aws_iam_user.bitbucket_user.name
  policy_arn = "arn:aws:iam::122639376858:policy/ECR_ReadOnly_Policy"
}

# BELOW CODE REPLACED BY ABOVE USE OF CUSTOMER MANAGED POLICY
# resource "aws_iam_user_policy" "ecr_read_access" {
#   name = "ECR_ReadOnly_Policy"
#   user = aws_iam_user.bitbucket_user.name

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ecr:GetRegistryPolicy",
#           "ecr:DescribeImageScanFindings",
#           "ecr:GetLifecyclePolicyPreview",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:DescribeRegistry",
#           "ecr:DescribePullThroughCacheRules",
#           "ecr:DescribeImageReplicationStatus",
#           "ecr:GetAuthorizationToken",
#           "ecr:ListTagsForResource",
#           "ecr:ListImages",
#           "ecr:BatchGetRepositoryScanningConfiguration",
#           "ecr:GetRegistryScanningConfiguration",
#           "ecr:BatchGetImage",
#           "ecr:DescribeImages",
#           "ecr:DescribeRepositories",
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:GetRepositoryPolicy",
#           "ecr:GetLifecyclePolicy"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#         Sid      = "EcrAccessToAllECR"
#       }
#     ]
#   })
# }

resource "aws_iam_user_policy_attachment" "ecr_write_access_attach" {
  user       = aws_iam_user.bitbucket_user.name
  policy_arn = "arn:aws:iam::122639376858:policy/ECS_Write_Policy"
}

# BELOW CODE REPLACED BY ABOVE USE OF CUSTOMER MANAGED POLICY
# resource "aws_iam_user_policy" "ecs_access" {
#   name = "ECS_Write_Policy"
#   user = aws_iam_user.bitbucket_user.name

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ecs:RegisterTaskDefinition",
#           "ecs:UpdateService"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#         Sid      = "ECSTaskAccess"
#       }
#     ]
#   })
# }

resource "aws_iam_user_policy" "passrole_access" {
  name = "Connect_ECS_Pass_Role_Policy"
  user = aws_iam_user.bitbucket_user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = [
          aws_iam_role.task_execution_role.arn,
          "arn:aws:iam::${local.account_id}:role/connect-task-role-prod",
          "arn:aws:iam::${local.account_id}:role/connect-execution-role-prod"
        ]
        Sid      = "PolicyStatementToAllowUserToPassSpecificRoles"
      }
    ]
  })
}

resource "aws_iam_role_policy" "task_execution_policy" {
  name = "connect_ecs_execution_role"
  role = aws_iam_role.task_execution_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
            Action = [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer"
            ],
            Resource = ["arn:aws:ecr:${var.prod_region}:${local.account_id}:repository/connect", "arn:aws:ecr:${var.dr_region}:${local.account_id}:repository/connect"],
            Effect   = "Allow"
        },
        {
            Action = "ecr:GetAuthorizationToken",
            Resource = "*",
            Effect = "Allow"
        },
        {
            Action   = "ssm:GetParameters",
            Resource = ["arn:aws:ssm:${var.prod_region}:${local.account_id}:parameter/connect/prod/*", "arn:aws:ssm:${var.dr_region}:${local.account_id}:parameter/connect/prod/*"],
            Effect   = "Allow"
        }
    ]
  })
}

resource "aws_iam_role" "task_execution_role" {
  name = "connect_ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

output "aws_iam_user_arn" {
  value = aws_iam_user.bitbucket_user.arn
}