variable "iam_user_name" {
  description = "IAM User Name"
  default     = "sa-bitbucket-connect-genesys"
  type        = string
}

# value of this variable needs to be passed
variable "ecr_arn" {
  description = "Elastic Container Registry ARN"
  type        = string
}

variable "task_role_arn" {
  description = "Elastic Container Service Task Role ARN"
  type        = string
}

variable "execution_role_arn" {
  description = "Elastic Container Service Execution Role"
  type        = string
}