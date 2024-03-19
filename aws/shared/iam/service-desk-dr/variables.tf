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

variable "aish_switch_role_profile" {
  description = "AWS Profile"
  default     = "ai-selfhelp"
  type        = string
}

variable "aish_switch_role_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "AI-Self-Help"
  type        = string
}

variable "prod_switch_role_profile" {
  description = "AWS Profile"
  default     = "us-prod"
  type        = string
}

variable "prod_switch_role_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}

variable "iam_group_name" {
  description = "Service Desk DR Group Name"
  default     = "Service-Desk-DR"
  type        = string
}
variable "assume_role_policy_name" {
  description = "Assume Role Policy"
  default     = "service-desk-dr-assume-role-policy"
  type        = string
}
variable "assumed_role" {
  description = "Switch Role Assumed Role"
  default     = "service-desk-dr-role-assumed"
  type        = string
}