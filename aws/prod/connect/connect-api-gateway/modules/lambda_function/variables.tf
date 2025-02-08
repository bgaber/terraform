variable "lambda_function_name" {
  description = "Lambda Function Name"
  default     = "process-twilio-message"
  type        = string
}

variable "lambda_function_description" {
  description = "Lambda Function Description"
  default     = "Process Twilio Message"
  type        = string
}

variable "s3_bucket" {
  description = "Lambda Function Name"
  default     = "connect-ai-selfhelp-bucket"
  type        = string
}

variable "lambda_deployment_pkg" {
  description = "Lambda Deployment Package"
  default     = "process-twilio-message-8c96161a-14c6-4769-a496-e30801524d07.zip"
  type        = string
}

variable "lambda_layer_deployment_pkg" {
  description = "Lambda Layer Deployment Package"
  default     = "twilio.zip"
  type        = string
}

variable "lambda_timeout_value" {
  description = "Lambda Timeout Value"
  default     = 15
  type        = number
}