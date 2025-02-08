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

variable "switch_role_profile" {
  description = "AWS Profile"
  default     = "us-prod"
  type        = string
}

variable "switch_role_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}

variable "iam_group_name" {
  description = "Lex Group Name"
  default     = "AI-SelfHelp-Lex-Admin"
  type        = string
}
variable "assume_role_policy_name" {
  description = "Assume Role Policy"
  default     = "ai-self-help-lex-admin"
  type        = string
}
variable "assumed_role" {
  description = "Switch Role Assumed Role"
  default     = "ai-self-help-lex-admin-role-assumed"
  type        = string
}