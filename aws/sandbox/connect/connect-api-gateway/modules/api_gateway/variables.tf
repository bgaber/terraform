variable "rest_api_name"{
    type = string
    description = "API Gateway Name"
    default = "twilio-async-api"
}

variable "rest_api_description" {
  description = "API Gateway Name"
  default     = "Connect API Gateway"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Lambda Invoke ARN"
  type        = string
}