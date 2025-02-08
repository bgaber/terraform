variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "profile" {
  description = "AWS Profile"
  default     = "test"
  type        = string
}

variable "cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}

variable "connect_s3_bucket" {
  description = "Connect S3 Lambda Bucket"
  default     = "connect-cognito-bucket"
  type        = string
}

variable "pre_tok_gen_lambda_archive" {
  description = "Lambda Archive Filename"
  default     = "connect-pre-token-generator-2c1e9144-1518-42ac-8301-6d02e5178198.zip"
  type        = string
}

variable "function_name" {
  description = "Name of the Pretoken Generator Lambda Function"
  default     = "connect-pre-token-generator"
  type        = string
}