terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.login_cred_profile
  default_tags {
    tags = {
      Created     = "09 Jun 2023"
      Creator     = "Brian Gaber using Terraform"
      Owner       = "Rex Hiltz"
      Application = "AI Self Help"
      Incident    = "INC45985229"
    }
  }
}

resource "aws_iam_user" "user_one" {
  name = "bp219831"
  tags = {
    Name  = "Bhavin Padiya"
    email = "bhavin.padiya@compucom.com"
  }
}

resource "aws_iam_user" "user_two" {
  name = "la222331"
  tags = {
    Name  = "Angel Hernandez Alvarado"
    email = "angel.alvaradohernandez@compucom.com"
  }
}

data "aws_iam_group" "dev_gp_name" {
  group_name = var.developer_group_name
}

resource "aws_iam_group_membership" "developers" {
  name = "developers-group-membership"

  users = [
    aws_iam_user.user_one.name,
    aws_iam_user.user_two.name
  ]

  group = data.aws_iam_group.dev_gp_name.group_name
}


output "group_name" {
  value = aws_iam_group_membership.developers.group
}

output "group_users" {
  value = aws_iam_group_membership.developers.users
}