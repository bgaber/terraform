variable "schedule_name" {
  description = "EventBridge Schedule Name"
  default     = "elite-password-rotation-rule"
  type        = string
}

variable "schedule_description" {
  description = "EventBridge Schedule Description"
  default     = "Elite User Password Rotation"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda Function Name"
  type        = string
}

variable "lambda_function_description" {
  description = "Lambda Function Description"
  default     = "Elite User Password Rotation"
  type        = string
}

variable "s3_bucket_name" {
  description = "Lambda Archives For Terraform"
  type        = string
}

variable "lambda_deployment_pkg" {
  description = "Lambda Deployment Package"
  default     = "elite-password-rotation.zip"
  type        = string
}