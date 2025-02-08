variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "acm_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Dev"
  type        = string
}

variable "r53_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}