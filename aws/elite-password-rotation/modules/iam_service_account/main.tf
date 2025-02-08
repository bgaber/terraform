data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_iam_user" "service_account" {
  name = var.iam_user_name
}

resource "aws_iam_user_policy" "lambda_limited_access" {
  name = "LimitedLambdaAccess"
  user = aws_iam_user.service_account.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LimitedLambdaAccess",
            "Effect": "Allow",
            "Action": [
                "lambda:DisableReplication",
                "lambda:EnableReplication",
                "lambda:Invoke*",
                "lambda:ListTags",
                "lambda:TagResource",
                "lambda:UntagResource",
                "lambda:UpdateFunctionCode*"
            ],
            "Resource": "arn:aws:lambda:us-east-1:${local.account_id}:function:${var.lambda_function_name}"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "s3_limited_access" {
  name = "ResourceLimitedS3Access"
  user = aws_iam_user.service_account.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        "Resource": [
          "arn:aws:s3:::${var.s3_bucket_name}/*",
          "arn:aws:s3:::${var.s3_bucket_name}"
        ]
      }
    ]
}
EOF
}

output "service_account_arn" {
  value = aws_iam_user.service_account.arn
}