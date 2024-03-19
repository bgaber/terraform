# The purpose of this Terraform code is to give certain users developer access in the Shared and AI-SelfHelp accounts for the Service Desk DR project
# Added Prod role

data "aws_caller_identity" "shared" {}

data "aws_caller_identity" "aish_switch" {
  provider = aws.aish_switch_role
}

data "aws_caller_identity" "prod_switch" {
  provider = aws.prod_switch_role
}

locals {
    shared_account_id    = data.aws_caller_identity.shared.account_id
    aish_switched_account_id  = data.aws_caller_identity.aish_switch.account_id
    prod_switched_account_id  = data.aws_caller_identity.prod_switch.account_id
}

# Developers
resource "aws_iam_user" "user_one" {
  name = "jm023119"
  tags = {
    Name  = "Julius Malixi"
    email = "julius.malixi@compucom.com"
  }
}

resource "aws_iam_user" "user_two" {
  name = "aa831029"
  tags = {
    Name  = "Anwar Ahmad"
    email = "anwar.ahmad@compucom.com"
  }
}

resource "aws_iam_user" "user_three" {
  name = "md023676"
  tags = {
    Name  = "Mike Digos"
    email = "mike.digos@compucom.com"
  }
}

resource "aws_iam_user" "user_four" {
  name = "bv023674"
  tags = {
    Name  = "Belen Vergara"
    email = "belen.vergara@compucom.com"
  }
}

resource "aws_iam_user" "user_five" {
  name = "rd023675"
  tags = {
    Name  = "Roderick Devera"
    email = "roderick.devera@compucom.com"
  }
}

# Shared Account IAM Group
resource "aws_iam_group" "service_desk_dr" {
  name = var.iam_group_name
}

# Shared Account IAM Group Membership
resource "aws_iam_group_membership" "team" {
  name = "service-desk-dr-group-membership"

  users = [
    aws_iam_user.user_one.name,
    aws_iam_user.user_two.name,
    aws_iam_user.user_three.name,
    aws_iam_user.user_four.name,
    aws_iam_user.user_five.name,
  ]

  group = aws_iam_group.service_desk_dr.name
}

# Shared Account IAM Group Assume Role Policy to AI SelfHelp Account
resource "aws_iam_policy" "aish_assume_role_policy" {
  name = join("-", ["AISH", var.assume_role_policy_name])

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "AssumeContentCreatorRole",
        Effect : "Allow",
        Resource : "arn:aws:iam::${local.aish_switched_account_id}:role/${var.assumed_role}"
        Action : "sts:AssumeRole"
      },
    ]
  })
}

# Shared Account IAM Group Assume Role Policy to Prod Account
resource "aws_iam_policy" "prod_assume_role_policy" {
  name = join("-", ["Prod", var.assume_role_policy_name])

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "AssumeContentCreatorRole",
        Effect : "Allow",
        Resource : "arn:aws:iam::${local.prod_switched_account_id}:role/${var.assumed_role}"
        Action : "sts:AssumeRole"
      },
    ]
  })
}

# Shared Account IAM Group Permissions policies
resource "aws_iam_group_policy_attachment" "aish-policy-attach" {
  group      = aws_iam_group.service_desk_dr.name
  policy_arn = aws_iam_policy.aish_assume_role_policy.arn
}

resource "aws_iam_group_policy_attachment" "prod-policy-attach" {
  group      = aws_iam_group.service_desk_dr.name
  policy_arn = aws_iam_policy.prod_assume_role_policy.arn
}

resource "aws_iam_group_policy_attachment" "custom-iam-access-key-and-MFA" {
  group      = aws_iam_group.service_desk_dr.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/custom-iam-access-key-and-MFA"
}

resource "aws_iam_group_policy_attachment" "deny-ssm" {
  group      = aws_iam_group.service_desk_dr.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/DenySSM"
}

resource "aws_iam_group_policy_attachment" "force-mfa" {
  group      = aws_iam_group.service_desk_dr.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/Force_MFA"
}

resource "aws_iam_group_policy_attachment" "iam-user-change-password" {
  group      = aws_iam_group.service_desk_dr.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_group_policy_attachment" "lambda-readonly-access" {
  group      = aws_iam_group.service_desk_dr.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "cloudwatch-readonly-access" {
  group      = aws_iam_group.service_desk_dr.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_policy" "lambda_write_policy" {
  name        = "ServiceDeskDR_LambdaPolicy"
  description = join(" ", [var.iam_group_name, "Lambda policy"])

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:CreateFunction",
				  "lambda:TagResource",
          "lambda:PublishLayerVersion",
          "lambda:InvokeAsync",
          "lambda:CreateEventSourceMapping",
          "lambda:UntagResource",
          "lambda:PutFunctionConcurrency",
          "lambda:PutFunctionEventInvokeConfig",
          "lambda:CreateCodeSigningConfig",
          "lambda:PutFunctionCodeSigningConfig",
          "lambda:UpdateFunctionUrlConfig",
          "lambda:CreateFunctionUrlConfig",
          "lambda:UpdateFunctionEventInvokeConfig",
          "lambda:UpdateEventSourceMapping",
          "lambda:InvokeFunctionUrl",
          "lambda:UpdateFunctionCodeSigningConfig",
          "lambda:InvokeFunction",
          "lambda:UpdateFunctionConfiguration",
          "lambda:UpdateAlias",
          "lambda:UpdateCodeSigningConfig",
          "lambda:UpdateFunctionCode",
          "lambda:PutRuntimeManagementConfig",
          "lambda:PutProvisionedConcurrencyConfig",
          "lambda:PublishVersion",
          "lambda:CreateAlias",
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = [
            "*"
        ]
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "lambda-write-access" {
  group      = aws_iam_group.service_desk_dr.name
  policy_arn = aws_iam_policy.lambda_write_policy.arn
}

resource "aws_iam_policy" "cloudwatch_write_policy" {
  name        = "ServiceDeskDR_CloudWatchPolicy"
  description = join(" ", [var.iam_group_name, "CloudWatch policy"])

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:PutDataProtectionPolicy",
          "logs:PutDestinationPolicy",
          "logs:PutQueryDefinition",
          "logs:PutAccountPolicy",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "logs:CreateLogDelivery",
          "logs:CreateExportTask",
          "logs:PutMetricFilter",
          "logs:CreateLogStream",
          "logs:UpdateLogDelivery",
          "logs:CancelExportTask",
          "logs:AssociateKmsKey",
          "logs:PutSubscriptionFilter",
          "logs:PutRetentionPolicy",
          "logs:PutDestination"
        ]
        Effect   = "Allow"
        Resource = [
            "*"
        ]
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "cloudwatch-write-access" {
  group      = aws_iam_group.service_desk_dr.name
  policy_arn = aws_iam_policy.cloudwatch_write_policy.arn
}

# AI SelfHelp Account Role that is assumed from Shared Account
resource "aws_iam_role" "aish_assumed_role" {
  provider = aws.aish_switch_role
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

# AI SelfHelp Account Role Permissions policies
resource "aws_iam_role_policy_attachment" "power-user-access" {
  provider   = aws.aish_switch_role
  role       = aws_iam_role.aish_assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# Prod Account Role that is assumed from Shared Account
resource "aws_iam_role" "prod_assumed_role" {
  provider = aws.prod_switch_role
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

# Prod Account Role Permissions policies
resource "aws_iam_role_policy_attachment" "amazon-connect-full-access" {
  provider   = aws.prod_switch_role
  role       = aws_iam_role.prod_assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonConnect_FullAccess"
}

# resource "aws_iam_role_policy_attachment" "amazon-connect-ro-access" {
#   provider   = aws.prod_switch_role
#   role       = aws_iam_role.prod_assumed_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonConnectReadOnlyAccess"
# }

# Prod Account Role limited IAM permissions

# Outputs
output "group_arn" {
  value = aws_iam_group.service_desk_dr.arn
}

output "group_name" {
  value = aws_iam_group.service_desk_dr.name
}

output "aish_assumed_role_id" {
  value = aws_iam_role.aish_assumed_role.id
}

output "aish_assumed_role_arn" {
  value = aws_iam_role.aish_assumed_role.arn
}

output "aish_assumed_role_name" {
  value = aws_iam_role.aish_assumed_role.name
}

output "prod_assumed_role_id" {
  value = aws_iam_role.prod_assumed_role.id
}

output "prod_assumed_role_arn" {
  value = aws_iam_role.prod_assumed_role.arn
}

output "prod_assumed_role_name" {
  value = aws_iam_role.prod_assumed_role.name
}