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
  default     = "ca-prod"
  type        = string
}

variable "switch_role_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "CA-Prod"
  type        = string
}

variable "iam_group_name" {
  description = "Canada Network Group Name"
  default     = "Canada-Network"
  type        = string
}
variable "assume_role_policy_name" {
  description = "Assume Role Policy"
  default     = "canada-network-readonly"
  type        = string
}
variable "assumed_role" {
  description = "Switch Role Assumed Role"
  default     = "canada-network-role-assumed"
  type        = string
}