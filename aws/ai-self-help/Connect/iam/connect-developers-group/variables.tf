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
  default     = "us-test"
  type        = string
}

variable "switch_role_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}

variable "iam_group_name" {
  description = "IAM Group Name"
  default     = "Connect-Developers"
  type        = string
}
variable "assume_role_policy_name" {
  description = "Assume Role Policy"
  default     = "assumerole-connect-dev"
  type        = string
}

variable "assumed_role" {
  description = "Switch Role Assumed Role"
  default     = "connect-role-assumed"
  type        = string
}