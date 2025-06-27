resource "aws_accessanalyzer_analyzer" "fedramp" {
  analyzer_name = var.aws_iam_access_analyzer_name
  type = "ACCOUNT_UNUSED_ACCESS"
  configuration {
    unused_access {
      unused_access_age = 90
    }
  }
}

output "aws_iam_access_analyzer_arn" {
  value = aws_accessanalyzer_analyzer.fedramp.arn
}

output "aws_iam_access_analyzer_id" {
  value = aws_accessanalyzer_analyzer.fedramp.id
}