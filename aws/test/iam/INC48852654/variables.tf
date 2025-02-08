variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "us-test"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}

variable "iam_user_name" {
  description = "IAM User Name"
  default     = "sa-control-m"
  type        = string
}

variable "iam_policy_name" {
  description = "IAM Policy Name"
  default     = "Control_M_S3_Write_Policy"
  type        = string
}


variable "s3_bucket_name" {
  description = "IAM Policy Description"
  default     = "test1-snowflake-s3"
  type        = string
}