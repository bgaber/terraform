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

variable "lambda_function_name" {
  description = "Lambda Function Name"
  default     = "kendra_Search"
  type        = string
}

variable "lambda_function_description" {
  description = "Lambda Function Description"
  default     = "Kendra Search Function"
  type        = string
}

variable "s3_bucket" {
  description = "Lambda Function Name"
  default     = "connect-ai-selfhelp-bucket"
  type        = string
}

variable "lambda_deployment_pkg" {
  description = "Lambda Deployment Package"
  default     = "kendra_Search-9daf8d1c-9dd7-4b07-b1a2-53f6764f6eec.zip"
  type        = string
}