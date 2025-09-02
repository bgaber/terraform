variable "lambda_assume_role" {
  description = "IAM Assume Role Name"
  type        = string
}

variable "lambda_policy" {
  description = "IAM Policy Name"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the Lambda role from FedRAMP Security account"
  type        = string
}
