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
  default     = ["206.178.22.0/26", "206.178.22.64/26", "161.108.91.192/27", "161.108.91.224/27", "161.108.91.32/28", "161.108.91.48/28", "161.108.175.32/28"]
  type        = list(string)
}