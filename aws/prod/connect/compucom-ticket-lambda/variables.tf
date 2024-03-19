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
  default     = "compucom_ticket_create"
  type        = string
}

variable "lambda_function_description" {
  description = "Lambda Function Description"
  default     = "Compucom Ticket Create Function"
  type        = string
}

variable "s3_bucket" {
  description = "Lambda Function Name"
  default     = "connect-ai-selfhelp-bucket"
  type        = string
}

variable "lambda_deployment_pkg" {
  description = "Lambda Deployment Package"
  default     = "compucom_ticket_create-a7374d49-3f2a-4930-b84c-7fa27b716c94.zip"
  type        = string
}