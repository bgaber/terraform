terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "default"
}

resource "aws_iam_user" "user" {
  name = var.username
  tags = {
    Name = var.fullname
    Creator = "Terraform"
  }
}

resource "aws_iam_user_policy_attachment" "prod-attach" {
  count = contains(var.accounts, "prod") ? 1 : 0
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::472510080448:policy/AWSProdReadOnly"
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  count = contains(var.accounts, "test") ? 1 : 0
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::472510080448:policy/AWSTestReadOnly"
}

resource "aws_iam_user_policy_attachment" "dev-attach" {
  count = contains(var.accounts, "dev") ? 1 : 0
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::472510080448:policy/AWSDevReadOnly"
}

resource "aws_iam_user_policy_attachment" "canada-attach" {
  count = contains(var.accounts, "canada") ? 1 : 0
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::472510080448:policy/ACAProdReadOnly"
}

resource "aws_iam_user_policy_attachment" "mfa" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::472510080448:policy/custom-iam-access-key-and-MFA"
}

resource "aws_iam_user_policy_attachment" "deny-ssm" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::472510080448:policy/DenySSM"
}

resource "aws_iam_user_policy_attachment" "force-mfa" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::472510080448:policy/Force_MFA"
}

resource "aws_iam_user_policy_attachment" "change-password" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}