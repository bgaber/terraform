resource "aws_s3_bucket" "exp_mgt_s3_error_bucket" {
  bucket = var.s3_error_bucket_name
}

resource "aws_s3_bucket" "exp_mgt_s3_logs_bucket" {
  bucket = var.s3_logs_bucket_name
}

resource "aws_s3_bucket" "exp_mgt_s3_source_bucket" {
  bucket = var.s3_source_bucket_name
}

resource "aws_s3_object" "exp_mgt_s3_logs_prefixes" {
  bucket = aws_s3_bucket.exp_mgt_s3_logs_bucket.id
  for_each = toset(var.s3_bucket_prefixes)
  key    = each.key
}

resource "aws_s3_object" "exp_mgt_s3_source_prefixes" {
  bucket = aws_s3_bucket.exp_mgt_s3_source_bucket.id
  for_each = toset(var.s3_bucket_prefixes)
  key    = each.key
}

output "s3_error_bucket_name" {
  value = aws_s3_bucket.exp_mgt_s3_error_bucket.id
}
output "s3_error_bucket_arn" {
  value = aws_s3_bucket.exp_mgt_s3_error_bucket.arn
}

output "s3_logs_bucket_name" {
  value = aws_s3_bucket.exp_mgt_s3_logs_bucket.id
}

output "s3_logs_bucket_arn" {
  value = aws_s3_bucket.exp_mgt_s3_logs_bucket.arn
}

output "s3_source_bucket_name" {
  value = aws_s3_bucket.exp_mgt_s3_source_bucket.id
}

output "s3_source_bucket_arn" {
  value = aws_s3_bucket.exp_mgt_s3_source_bucket.arn
}