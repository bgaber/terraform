variable "lambda_function_name" {
  description = "Lambda Function Name"
  default     = "cc-langchain-agent"
  type        = string
}

variable "lambda_function_description" {
  description = "Lambda Function Description"
  default     = "Compucom langchain agent"
  type        = string
}

variable "s3_bucket" {
  description = "Lambda Function Name"
  default     = "connect-ai-selfhelp-bucket"
  type        = string
}

variable "lambda_deployment_pkg" {
  description = "Lambda Deployment Package"
  default     = "cc-langchain-agent-3b95eb67-58a6-426f-ba03-4fb504b47bd3.zip"
  type        = string
}

variable "lambda_layer_deployment_pkg1" {
  description = "Langchain Lambda Layer Deployment Package"
  default     = "cc-langchain-agent-layer-7a191141-33bc-480d-94f5-5d5e077ad5a9.zip"
  type        = string
}

variable "lambda_layer_deployment_pkg2" {
  description = "Python Lambda Layer Deployment Package"
  default     = "twilio_python_layer-dff6b425-8678-4d7a-a38b-57d998dd2093.zip"
  type        = string
}

variable "lambda_timeout_value" {
  description = "Lambda Timeout Value"
  default     = 60
  type        = number
}