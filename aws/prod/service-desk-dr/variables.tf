variable "region" {
  description = "AWS Region"
  default     = "ca-central-1"
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

variable "instance_alias_name" {
  description = "Amazon Connect Instance Alias Name"
  default     = "compucomdr"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 Bucket Name"
  default     = "amazon-connect-d1ca945d0bd6"
  type        = string
}