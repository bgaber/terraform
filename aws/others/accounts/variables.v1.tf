variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "shared_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Shared"
  type        = string
}

variable "prod_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}

variable "test_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}

variable "dev_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Dev"
  type        = string
}

variable "canada_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "CA-Prod"
  type        = string
}

variable "sandbox_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Sandbox"
  type        = string
}

variable "twilio_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Twilio"
  type        = string
}

variable "pkg_factory_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "PkgFactory"
  type        = string
}

variable "aish_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "AI-Self-Help"
  type        = string
}
