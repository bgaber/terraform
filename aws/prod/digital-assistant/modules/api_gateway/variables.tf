variable "rest_api_name"{
    type = string
    description = "API Gateway Name"
    default = "cc-genai"
}

variable "rest_api_description" {
  description = "API Gateway Name"
  default     = "Digital Assistant API Gateway"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Lambda Invoke ARN"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda Function Name"
  default     = "cc-langchain-agent"
  type        = string
}

variable "api_gw_resources" {
  description = "API Gateway Resources"
  type    = list(string)
  default = ["invoke-agent", "invoke-agent-prod", "invoke-agent-uat", "search-kb", "sync-kb"]
}