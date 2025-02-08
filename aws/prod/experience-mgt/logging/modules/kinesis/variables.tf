variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "us-prod"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 Bucket Name"
  #default     = "cc-xli-cw-logs-prod-source"
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
    "lex/compucom"    = "/connect/lex/compucom"
    "lex/CAMH"        = "/connect/lex/CAMH"
    "lex/Covetrus"    = "/connect/lex/Covetrus"
    "lex/Firstenergy" = "/connect/lex/Firstenergy"
    "lex/Firstgroup"  = "/connect/lex/Firstgroup"
    "lex/MossAdams"   = "/connect/lex/MossAdams"
    "lex/Sonic"       = "/connect/lex/Sonic"
    "lex/Veolia"      = "/connect/lex/Veolia"
    "kendra"          = "/aws/lambda/kendra_Search"
    "connect"         = "/aws/ecs/connect-cluster-prod"
  }
}