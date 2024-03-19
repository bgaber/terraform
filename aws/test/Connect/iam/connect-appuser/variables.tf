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

variable "user_name" {
  description = "IAM User Name"
  default     = "connect-appuser"
  type        = string
}

variable "policy_name" {
  description = "IAM Policy Name"
  default     = "connect-app-policy"
  type        = string
}