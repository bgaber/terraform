variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "s3_bucket_name" {
  description = "Lambda Archives For Terraform"
  default     = "noc-lambda-archives"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda Function Name"
  default     = "elite_password_rotation"
  type        = string
}

variable "lambda_deployment_pkg" {
  description = "Lambda Deployment Package"
  default     = "elite-password-rotation.zip"
  type        = string
}