variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "profile" {
  description = "AWS Profile"
  default     = "sandbox"
  type        = string
}

variable "cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Sandbox"
  type        = string
}