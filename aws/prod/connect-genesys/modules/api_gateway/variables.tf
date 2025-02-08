variable "rest_api_name"{
    type = string
    description = "API Gateway Name"
    default = "genesys-bot"
}

variable "rest_api_description" {
  description = "API Gateway Name"
  default     = "Connect Genesys API Gateway"
  type        = string
}

variable "lambda_arn" {
  description = "Lambda ARN"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Lambda Invoke ARN"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda Function Name"
  default     = "genesys-post-utterance"
  type        = string
}

variable "api_gw_resources" {
  description = "API Gateway Resources"
  type    = list(string)
  default = ["prod"]
}

# variable "api_gw_resource" {
#   description = "API Gateway Resource"
#   default     = "prod"
#   type        = string
# }