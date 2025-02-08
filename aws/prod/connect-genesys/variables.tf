variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}

variable "route53_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Shared"
  type        = string
}