data "aws_caller_identity" "shared" {}

data "aws_caller_identity" "switch" {
  provider = aws.switch_role
}

locals {
    shared_account_id    = data.aws_caller_identity.shared.account_id
    switched_account_id  = data.aws_caller_identity.switch.account_id
}

data "aws_iam_user" "user_one" {
  user_name = "sd88335"
}
data "aws_iam_user" "user_two" {
  user_name = "je98971"
}
data "aws_iam_user" "user_three" {
  user_name = "ig217163"
}
data "aws_iam_user" "user_four" {
  user_name = "rm217162"
}
data "aws_iam_user" "user_five" {
  user_name = "an849200"
}
data "aws_iam_user" "user_six" {
  user_name = "fq200540"
}
data "aws_iam_user" "user_seven" {
  user_name = "cs215481"
}
data "aws_iam_user" "user_eight" {
  user_name = "rh92115"
}

resource "aws_iam_group" "lex_administrators" {
  name = var.iam_group_name
}

resource "aws_iam_group_membership" "team" {
  name = "ai-self-help-lex-admin-group-membership"

  users = [
    data.aws_iam_user.user_one.user_name,
    data.aws_iam_user.user_two.user_name,
    data.aws_iam_user.user_three.user_name,
    data.aws_iam_user.user_four.user_name,
    data.aws_iam_user.user_five.user_name,
    data.aws_iam_user.user_six.user_name,
    data.aws_iam_user.user_seven.user_name,
    data.aws_iam_user.user_eight.user_name,
  ]

  group = aws_iam_group.lex_administrators.name
}

resource "aws_iam_policy" "assume_role_policy" {
  name = var.assume_role_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "AssumeProdLexAdminRole",
        Effect : "Allow",
        Resource : "arn:aws:iam::${local.switched_account_id}:role/${var.assumed_role}"
        Action : "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "cc_attach" {
  group      = aws_iam_group.lex_administrators.name
  policy_arn = aws_iam_policy.assume_role_policy.arn
}

resource "aws_iam_group_policy_attachment" "custom_iam_access_key_and_MFA" {
  group      = aws_iam_group.lex_administrators.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/custom-iam-access-key-and-MFA"
}

resource "aws_iam_group_policy_attachment" "deny_ssm" {
  group      = aws_iam_group.lex_administrators.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/DenySSM"
}

resource "aws_iam_group_policy_attachment" "force_mfa" {
  group      = aws_iam_group.lex_administrators.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/Force_MFA"
}

resource "aws_iam_group_policy_attachment" "iam_user_change_password" {
  group      = aws_iam_group.lex_administrators.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
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

resource "aws_iam_role_policy_attachment" "lex_full_access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonLexFullAccess"
}

# resource "aws_iam_role_policy_attachment" "lex_ro_access" {
#   provider   = aws.switch_role
#   role       = aws_iam_role.assumed_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonLexReadOnly"
# }

# resource "aws_iam_role_policy" "inline_lex_write_policy" {
#   provider = aws.switch_role
#   name     = "LexLimitedWriteAccess"
#   role     = aws_iam_role.assumed_role.id

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     Version: "2012-10-17",
#     Statement: [
#         {
#           Sid: "ConnectLambdaWriteAccess",
#           Effect: "Allow",
#           Action: [
#               "lex:BuildBotLocale",
#               "lex:UpdateBotAlias"
#           ],
#           Resource: [
#               "arn:aws:lex:us-west-2:122639376858:bot/OWGCYIRCOS",
#               "arn:aws:lex:us-west-2:122639376858:bot-alias/OWGCYIRCOS/*"
#           ]
#         }
#     ]
#   })
# }

resource "aws_iam_role_policy_attachment" "kendra_ro_access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKendraReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_ro_access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_ro_access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_support_access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

resource "aws_iam_role_policy_attachment" "bedrock_ro_access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonBedrockReadOnly"
}

resource "aws_iam_role_policy" "inline_lambda_write_policy" {
  provider = aws.switch_role
  name     = "ConnectLambdaLimitedWriteAccess"
  role     = aws_iam_role.assumed_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
          Sid: "LambdaWriteAccess",
          Effect: "Allow",
          Action: [
              "lambda:*"
          ],
          Resource: [
              "arn:aws:lambda:us-east-1:${local.switched_account_id}:function:*-router",
              "arn:aws:lambda:us-east-1:${local.switched_account_id}:function:kendra_Search"
          ]
        }
    ]
  })
}

resource "aws_iam_role_policy" "inline_kendra_passrole_access" {
  provider = aws.switch_role
  name     = "KendraPassRolePolicy"
  role     = aws_iam_role.assumed_role.id

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
          "arn:aws:iam::${local.switched_account_id}:role/service-role/AmazonKendra-us-east-1-cc-kb"
        ]
        Sid = "PolicyStatementToAllowRoleToPassSpecificRoles"
      }
    ]
  })
}

resource "aws_iam_role_policy" "inline_kendra_write_policy" {
  provider = aws.switch_role
  name     = "KendraLimitedWriteAccess"
  role     = aws_iam_role.assumed_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
          Sid: "KendraLimitedWriteAccess",
          Effect: "Allow",
          Action: [
              "kendra:SubmitFeedback",
              "kendra:StopDataSourceSyncJob",
              "kendra:StartDataSourceSyncJob",
              "kendra:CreateFaq",
              "kendra:DeleteFaq",
              "kendra:GetSnapshots",
              "kendra:UpdateIndex"
          ],
          Resource: "*"
        }
    ]
  })
}

resource "aws_iam_role_policy" "inline_s3_passrole_access" {
  provider = aws.switch_role
  name     = "S3PassRolePolicy"
  role     = aws_iam_role.assumed_role.id

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
          "arn:aws:iam::${local.switched_account_id}:role/service-role/AmazonKendra-enterprise-s3"
        ]
        Sid = "PolicyStatementToAllowRoleToPassSpecificRoles"
      }
    ]
  })
}

resource "aws_iam_role_policy" "inline_s3_read_policy" {
  provider = aws.switch_role
  name     = "S3ReadAccess"
  role     = aws_iam_role.assumed_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
          Sid: "S3ReadAccess",
          Effect: "Allow",
          Action: [
            "s3:ListBucket",
            "s3:GetObject"
          ],
          Resource: [
            "arn:aws:s3:::compucom-voice-transcripts",
            "arn:aws:s3:::compucom-voice-transcripts/*",
            "arn:aws:s3:::compucom-voice-transcripts-prod",
            "arn:aws:s3:::compucom-voice-transcripts-prod/*"
          ]
        }
    ]
  })
}

resource "aws_iam_role_policy" "inline_iam_permission_mgt_policy" {
  provider = aws.switch_role
  name     = "IAMLimitedPermMgtAccess"
  role     = aws_iam_role.assumed_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
          Sid: "IamPermissionMgtAccess",
          Effect: "Allow",
          Action: [
            "iam:PutRolePolicy"
          ],
          Resource: "*",
          Condition: {
                "StringEquals": {
                    "iam:AWSServiceName": "lexv2.amazonaws.com"
                }
            }
        }
    ]
  })
}

output "group_arn" {
  value = aws_iam_group.lex_administrators.arn
}

output "group_name" {
  value = aws_iam_group.lex_administrators.name
}

output "assumed_role_id" {
  value = aws_iam_role.assumed_role.id
}

output "assumed_role_arn" {
  value = aws_iam_role.assumed_role.arn
}

output "assumed_role_name" {
  value = aws_iam_role.assumed_role.name
}