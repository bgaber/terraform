data "aws_caller_identity" "shared" {}

data "aws_caller_identity" "switch" {
  provider = aws.switch_role
}

locals {
    shared_account_id    = data.aws_caller_identity.shared.account_id
    switched_account_id  = data.aws_caller_identity.switch.account_id
}

resource "aws_iam_user" "user_one" {
  name = "jhannahs"
  tags = {
    Name  = "Joshua Hannahs"
    email = "joshua.hannahs@compucom.com"
  }
}

resource "aws_iam_user" "user_two" {
  name = "as188826"
  tags = {
    Name  = "Andres Santos Reyes"
    email = "andres.santosreyes@compucom.com"
  }
}

# resource "aws_iam_user" "user_three" {
#   name = "lf188653"
#   tags = {
#     Name  = "Luis Fuentes"
#     email = "luis.fuentes@compucom.com"
#   }
# }

resource "aws_iam_user" "user_four" {
  name = "tk216084"
  tags = {
    Name  = "Trevor Kirk"
    email = "trevor.kirk@compucom.com"
  }
}

resource "aws_iam_user" "user_five" {
  name = "kharris"
  tags = {
    Name  = "Ken Harris"
    email = "kharris@compucom.com"
  }
}

resource "aws_iam_group" "experience_mgt" {
  name = var.iam_group_name
}

resource "aws_iam_group_membership" "team" {
  name = "experience-management-group-membership"

  users = [
    aws_iam_user.user_one.name,
    aws_iam_user.user_two.name,
    aws_iam_user.user_four.name,
    aws_iam_user.user_five.name
  ]

  group = aws_iam_group.experience_mgt.name
}

resource "aws_iam_policy" "assume_role_policy" {
  name = var.assume_role_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "AssumeContentCreatorRole",
        Effect : "Allow",
        Resource : "arn:aws:iam::${local.switched_account_id}:role/${var.assumed_role_name}"
        Action : "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "cc-attach" {
  group      = aws_iam_group.experience_mgt.name
  policy_arn = aws_iam_policy.assume_role_policy.arn
}

###
resource "aws_iam_policy" "ro_assume_role_policy" {
  name = join("-", [var.ro_assume_role_policy_name, lower(each.key)])

  for_each    = var.ro_aws_accounts
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "Assume${each.key}ExpMgtReadOnlyRole",
        Effect : "Allow",
        Resource : "arn:aws:iam::${each.value}:role/${var.ro_assumed_role_name}"
        Action : "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "ro_policy_attach" {
  for_each    = var.ro_aws_accounts
  group      = aws_iam_group.experience_mgt.name
  policy_arn = aws_iam_policy.ro_assume_role_policy[each.key].arn
}
###

resource "aws_iam_group_policy_attachment" "custom-iam-access-key-and-MFA" {
  group      = aws_iam_group.experience_mgt.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/custom-iam-access-key-and-MFA"
}

resource "aws_iam_group_policy_attachment" "deny-ssm" {
  group      = aws_iam_group.experience_mgt.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/DenySSM"
}

resource "aws_iam_group_policy_attachment" "force-mfa" {
  group      = aws_iam_group.experience_mgt.name
  policy_arn = "arn:aws:iam::${local.shared_account_id}:policy/Force_MFA"
}

resource "aws_iam_group_policy_attachment" "iam-user-change-password" {
  group      = aws_iam_group.experience_mgt.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_role" "assumed_role" {
  provider = aws.switch_role
  name     = var.assumed_role_name

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

resource "aws_iam_role_policy_attachment" "power-user-access" {
  provider   = aws.switch_role
  role       = aws_iam_role.assumed_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}



output "group_arn" {
  value = aws_iam_group.experience_mgt.arn
}

output "group_name" {
  value = aws_iam_group.experience_mgt.name
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