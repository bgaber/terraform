variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "ai-self-help"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "AI-Self-Help"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 Bucket Name"
  default     = "cc-xli-cw-logs-uat"
  type        = string
}

variable "s3_compression_format" {
  description = "S3 Compression Format"
  default     = "UNCOMPRESSED"
  type        = string
}

variable "prefix_log_group" {
  description = "Map of S3 Prefix to CloudWatch Log Group"
  type = map
  default = {
    "connect" = "/aws/ecs/connect-cluster-uat"
    "kendra"  = "/aws/lambda/kendra_Search"
    "lex"     = "/connect/lex/Compucom"
    "twilio"  = "/aws/lambda/process-twilio-message"
  }
}

variable "lambda_transform_arn" {
  description = "Transform source records with AWS Lambda function"
  default     = "arn:aws:lambda:us-east-1:047453590376:function:FirehoseLogTransformation"
  type        = string
}