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
  default     = "process-twilio-message-deb26e79-c083-4788-9b10-1ac339d0661d.zip"
  type        = string
}