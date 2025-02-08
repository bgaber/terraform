data "aws_caller_identity" "prod" {}

locals {
    account_id = data.aws_caller_identity.prod.account_id
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
        Resource = [var.ecr_arn]
        Sid = "EcrAccessToSpecificECR"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "ecr_write_access_attach" {
  user       = aws_iam_user.bitbucket_user.name
  policy_arn = "arn:aws:iam::122639376858:policy/ECS_Write_Policy"
}

resource "aws_iam_user_policy_attachment" "ecr_read_access_attach" {
  user       = aws_iam_user.bitbucket_user.name
  policy_arn = "arn:aws:iam::122639376858:policy/ECR_ReadOnly_Policy"
}

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
          "${var.task_role_arn}",
          "arn:aws:iam::${local.account_id}:role/connect-task-role-prod",
          "arn:aws:iam::${local.account_id}:role/connect-execution-role-prod",
          "${var.execution_role_arn}"
        ]
        Sid      = "PolicyStatementToAllowUserToPassSpecificRoles"
      }
    ]
  })
}

output "bitbucket_user_arn" {
  value = aws_iam_user.bitbucket_user.arn
}