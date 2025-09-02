data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_assume_role" {
  name = var.lambda_assume_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = var.lambda_role_arn
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for SSM IAM Access
resource "aws_iam_policy" "lambda_policy" {
  name        = var.lambda_policy
  description = "Grants Lambda some access to SSM and EC2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:ListCommandInvocations",
          "ssm:GetCommandInvocation",
          "ssm:DescribeInstanceInformation",
          "ssm:DescribeDocument",
          "ssm:GetParameter"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment" {
  role       = aws_iam_role.lambda_assume_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


output "aws_iam_assume_role_arn" {
  value = aws_iam_role.lambda_assume_role.arn
}
