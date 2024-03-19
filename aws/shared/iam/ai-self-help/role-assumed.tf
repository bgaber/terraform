data "aws_caller_identity" "shared" {}

data "aws_caller_identity" "switch" {
  provider = aws.switch_role
}

locals {
    shared_account_id    = data.aws_caller_identity.shared.account_id
    switched_account_id  = data.aws_caller_identity.switch.account_id
}

resource "aws_iam_user" "user_one" {
  name = "sd88335"
  tags = {
    Name  = "Samantha Dookhoo"
    email = "samantha.dookhoo@compucom.com"
  }
}

resource "aws_iam_user" "user_two" {
  name = "je98971"
  tags = {
    Name  = "Roberto Espinosa"
    email = "roberto.espinosa@compucom.com"
  }
}

resource "aws_iam_user" "user_three" {
  name = "ig217163"
  tags = {
    Name  = "Israel Gonzalez"
    email = "israel.gonzalez@compucom.com"
  }
}

resource "aws_iam_user" "user_four" {
  name = "rm217162"
  tags = {
    Name  = "Raul Munguia"
    email = "raulmiguel.munguiagarcia@compucom.com"
  }
}

resource "aws_iam_user" "user_five" {
  name = "an849200"
  tags = {
    Name  = "Ana Nunez"
    email = "luisa.nunez@compucom.com"
  }
}

resource "aws_iam_user" "user_six" {
  name = "fq200540"
  tags = {
    Name  = "Fernando Quintana"
    email = "Fernando.Quintana@compucom.com"
  }
}

resource "aws_iam_user" "user_seven" {
  name = "cs215481"
  tags = {
    Name  = "Fernando Saucedo"
    email = "carlos.saucedo@compucom.com"
  }
}

resource "aws_iam_user" "user_eight" {
  name = "ls790529"
  tags = {
    Name  = "Louis St. Amand"
    email = "louis.st.amand@compucom.com"
  }
}

resource "aws_iam_group" "content_creators" {
  name = var.iam_group_name
}

resource "aws_iam_group_membership" "team" {
  name = "content_creators-group-membership"

  users = [
    aws_iam_user.user_one.name,
    aws_iam_user.user_two.name,
    aws_iam_user.user_three.name,
    aws_iam_user.user_four.name,
    aws_iam_user.user_five.name,
    aws_iam_user.user_six.name,
    aws_iam_user.user_seven.name,
    aws_iam_user.user_eight.name,
  ]

  group = aws_iam_group.content_creators.name
}

resource "aws_iam_policy" "assume_role_policy" {
  name = var.assume_role_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "AssumeContentCreatorRole",
        Effect : "Allow",
        Resource : "arn:aws:iam::${local.switched_account_id}:role/${var.assumed_role}"
        Action : "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "cc-attach" {
  group      = aws_iam_group.content_creators.name
  policy_arn = aws_iam_policy.assume_role_policy.arn
}

resource "aws_iam_group_policy_attachment" "custom-iam-access-key-and-MFA" {
  group      = aws_iam_group.content_creators.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/custom-iam-access-key-and-MFA"
}

resource "aws_iam_group_policy_attachment" "deny-ssm" {
  group      = aws_iam_group.content_creators.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/DenySSM"
}

resource "aws_iam_group_policy_attachment" "force-mfa" {
  group      = aws_iam_group.content_creators.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/Force_MFA"
}

resource "aws_iam_group_policy_attachment" "iam-user-change-password" {
  group      = aws_iam_group.content_creators.name
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

resource "aws_iam_role_policy_attachment" "lex-full-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonLexFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda-full-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_role_policy_attachment" "s3-full-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "kendra-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKendraReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch-ro-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "bedrock-full-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
}

output "group_arn" {
  value = aws_iam_group.content_creators.arn
}

output "group_name" {
  value = aws_iam_group.content_creators.name
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