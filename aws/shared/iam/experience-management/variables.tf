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
  default     = "ai-selfhelp"
  type        = string
}

variable "switch_role_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "AI-Self-Help"
  type        = string
}

variable "iam_group_name" {
  description = "Experience Management Creators Group Name"
  default     = "Experience-Management"
  type        = string
}
variable "assume_role_policy_name" {
  description = "Assume Role Policy"
  default     = "experience-management"
  type        = string
}

variable "assumed_role_name" {
  description = "Switch Role Assumed Role"
  default     = "experience-mgt-role-assumed"
  type        = string
}

variable "ro_assume_role_policy_name" {
  description = "Read Only Assume Role Policy"
  default     = "assume-experience-mgt-read-only-role-in"
  type        = string
}

variable "ro_assumed_role_name" {
  description = "Read Only Assumed Role"
  default     = "experience-mgt-read-only-role-assumed"
  type        = string
}

variable "ro_aws_accounts" {
  description = "Compucom AWS Accounts"
  type = map
  default = {
    "Prod"   = "122639376858"
    "Test"   = "300899438431"
    "Dev"    = "995437807815"
  }
}