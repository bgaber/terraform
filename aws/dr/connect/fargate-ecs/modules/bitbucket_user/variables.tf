variable "ecr_arn" {
  description = "Elastic Container Registry ARN"
  type        = string
}

variable "iam_user_name" {
  description = "IAM User Name"
  default     = "connect_for_bitbucket"
  type        = string
}