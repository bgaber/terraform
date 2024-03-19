variable "prod_region" {
  description = "Production AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "dr_region" {
  description = "DR AWS Region"
  default     = "us-west-2"
  type        = string
}

variable "ecr_arn" {
  description = "Elastic Container Registry ARN"
  type        = string
}

variable "iam_user_name" {
  description = "IAM User Name"
  default     = "connect_for_bitbucket"
  type        = string
}