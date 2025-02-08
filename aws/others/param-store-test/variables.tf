variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "shared"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Shared"
  type        = string
}

variable "username" {
  description = "Username"
  default     = "/ansible/windows/service-account/username"
  type        = string
}

variable "password" {
  description = "Password"
  default     = "/ansible/windows/service-account/password"
  type        = string
}