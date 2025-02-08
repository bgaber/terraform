variable "prod_region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "s3_error_bucket_name" {
  description = "S3 Error Bucket Name"
  type    = string
  default = "cc-xli-cw-logs-prod-errors"
}

variable "s3_logs_bucket_name" {
  description = "S3 Logs Bucket Name"
  type    = string
  default = "cc-xli-cw-logs-prod"
}

variable "s3_source_bucket_name" {
  description = "S3 Source Bucket Name"
  type    = string
  default = "cc-xli-cw-logs-prod-source"
}

variable "s3_bucket_prefixes" {
  description = "S3 Prefix Names"
  type    = list(string)
  default = ["connect/", "lex/compucom/", "lex/CAMH/", "lex/Covetrus/", "lex/Firstenergy/", "lex/Firstgroup/", "lex/MossAdams/", "lex/Sonic/", "lex/Veolia/", "kendra/"]
}