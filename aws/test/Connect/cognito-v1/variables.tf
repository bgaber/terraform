variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "profile" {
  description = "AWS Profile"
  default     = "test"
  type        = string
}

variable "cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}

variable "connect_s3_bucket" {
  description = "Connect S3 Lambda Bucket"
  default     = "connect-cognito-bucket"
  type        = string
}

variable "saml_file" {
  description = "Cognito User Pool IdP SAML Configuration File"
  default     = "metadata.xml"
  type        = string
}

variable "user_pool_name" {
  description = "Cognito User Pool Name"
  default     = "connect-user-pool-test"
  type        = string
}

variable "user_pool_app_client_name" {
  description = "Cognito User Pool App Client Name"
  default     = "connect-app-client"
  type        = string
}