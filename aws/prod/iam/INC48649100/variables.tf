variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "us-prod"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}

variable "iam_policy_description" {
  description = "IAM Policy Description"
  default     = "Policy for bucket"
  type        = string
}

variable "s3_bucket_name" {
  description = "IAM Policy Description"
  default     = "cc-xli-cw-logs-prod"
  type        = string
}

variable "trusted_account_arn" {
  description = "Trusted AWS Account"
  default     = "arn:aws:iam::021712061285:user/rmyk-s-vass0532"
  type        = string
}

variable "trusted_external_id" {
  description = "Trusted External Id"
  type        = string
}