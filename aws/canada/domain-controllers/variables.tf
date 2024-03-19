variable "region" {
  description = "AWS Region"
  default     = "ca-central-1"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "CA-Prod"
  type        = string
}

variable "us_cidrs" {
  description = "US Shared VPC CIDRs"
  default     = ["10.251.2.156/32", "10.251.5.163/32"]
  type        = list(string)
}