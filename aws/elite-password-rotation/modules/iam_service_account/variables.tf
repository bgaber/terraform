variable "iam_user_name" {
  description = "IAM User Name"
  default     = "elite-password-rotation-sa"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda Function Name"
  type        = string
}