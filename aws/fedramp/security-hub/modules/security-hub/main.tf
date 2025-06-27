resource "aws_securityhub_account" "fedramp" {
  enable_default_standards = false
}

data "aws_region" "current" {}

resource "aws_securityhub_standards_subscription" "aws_foundational" {
  depends_on    = [aws_securityhub_account.fedramp]
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0"
}

resource "aws_securityhub_standards_subscription" "aws_resource_tagging_std" {
  depends_on    = [aws_securityhub_account.fedramp]
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-resource-tagging-standard/v/1.0.0"
}

resource "aws_securityhub_standards_subscription" "cis3" {
  depends_on    = [aws_securityhub_account.fedramp]
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/cis-aws-foundations-benchmark/v/3.0.0"
}

resource "aws_securityhub_standards_subscription" "nist" {
  depends_on    = [aws_securityhub_account.fedramp]
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/nist-800-53/v/5.0.0"
}

output "aws_securityhub_account_arn" {
  value = aws_securityhub_account.fedramp.arn
}

output "aws_securityhub_account_id" {
  value = aws_securityhub_account.fedramp.id
}