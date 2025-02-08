resource "aws_iam_user" "bitbucket_service_account" {
  name = var.iam_user_name
}

resource "aws_iam_policy" "service_account_policy" {
  name        = "${var.iam_user_name}-policy"
  description = "Policy for ${var.iam_user_name} Service Account"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:ListImages",
          "ecr:GetAuthorizationToken",
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:RegisterTaskDefinition",
          "ecs:DescribeTaskDefinition"
        ],
        "Resource": "*"
      }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "iam_policy_attachment" {
  policy_arn = aws_iam_policy.service_account_policy.arn
  user       = aws_iam_user.bitbucket_service_account.name
}

output "bitbucket_user_arn" {
  value = aws_iam_user.bitbucket_service_account.arn
}