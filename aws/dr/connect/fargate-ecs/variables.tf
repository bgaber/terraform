variable "region" {
  description = "AWS Region"
  default     = "us-west-2"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}