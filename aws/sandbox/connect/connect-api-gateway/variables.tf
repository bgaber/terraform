variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Sandbox"
  type        = string
}