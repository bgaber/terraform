variable "iam_user_name" {
  description = "IAM User Name"
  default     = "sa-bitbucket-webchat"
  type        = string
}

variable "iam_policy_description" {
  description = "IAM Policy Description"
  default     = "Policy for bucket"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}