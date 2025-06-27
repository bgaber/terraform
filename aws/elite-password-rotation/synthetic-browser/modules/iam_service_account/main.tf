data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_iam_user" "service_account" {
  name = var.elite_passwd_rotation_service_account
}

resource "aws_iam_user_policy" "parameter_store_limited_access" {
  name = "LimitedParameterStoreAccess"
  user = aws_iam_user.service_account.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LimitedParameterStoreAccess",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter",
                "ssm:PutParameter"
            ],
            "Resource": "arn:aws:ssm:us-east-1:${local.account_id}:parameter/*"
        }
    ]
}
EOF
}

resource "aws_iam_access_key" "elite_passwd_rotation_service_account" {
  user    = aws_iam_user.service_account.name
}

# Outputs
output "service_account_id" {
  value = aws_iam_user.service_account.id
}

output "service_account_arn" {
  value = aws_iam_user.service_account.arn
}

output "service_account_name" {
  value = aws_iam_user.service_account.name
}

output "service_secret_id" {
  value = aws_iam_access_key.elite_passwd_rotation_service_account.id
}

output "service_secret_access_key" {
  value = aws_iam_access_key.elite_passwd_rotation_service_account.secret
  sensitive = true
}
