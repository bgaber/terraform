variable "lambda_role" {
  description = "Lambda IAM ROle"
  default     = "trigger-ssm-lambda-role"
  type        = string
}

variable "ssm_policy" {
  description = "SSM IAM Policy"
  default     = "TriggerSSMAccessPolicy"
  type        = string
}

variable "lambda_logging_policy_name" {
  description = "Lambda CloudWatch Log Policy Name"
  default     = "LambdaLoggingPolicy"
  type        = string
}

variable "lambda_name" {
  description = "Lambda Function Name"
  default     = "trigger-ssm-lambda"
  type        = string
}

variable "lambda_archive" {
  description = "Lambda Function Archive"
  default     = "trigger_ssm_lambda_function.zip"
  type        = string
}

variable "linux_ssm_document_name" {
  description = "Linux SSM Document Name"
  type        = string
}

variable "windows_ssm_document_name" {
  description = "Windows SSM Document Name"
  type        = string
}