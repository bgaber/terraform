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

variable "canada_cidrs" {
  description = "Canada VPC CIDRs"
  default     = ["161.108.175.48/28", "161.108.208.192/26", "161.108.208.128/26", "161.108.90.0/25", "161.108.90.128/25", "192.168.1.192/26", "192.168.1.128/26"]
  type        = list(string)
}