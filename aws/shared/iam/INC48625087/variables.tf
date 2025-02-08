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

variable "test_switch_role_profile" {
  description = "AWS Profile"
  default     = "us-test"
  type        = string
}

variable "test_switch_role_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}

variable "iam_user_name" {
  description = "User Name"
  default     = "hc102527"
  type        = string
}

variable "iam_full_name" {
  description = "Full Name"
  default     = "Horacio Chavez"
  type        = string
}
variable "iam_user_email" {
  description = "User Email Address"
  default     = "horacio.chavez@compucom.com"
  type        = string
}

variable "iam_group_name" {
  description = "Bonitasoft Group Name"
  default     = "Bonitasoft"
  type        = string
}

variable "assume_role_policy_name" {
  description = "Assume Role Policy"
  default     = "bonitasoft-assume-role-policy"
  type        = string
}

variable "assumed_role" {
  description = "Switch Role Assumed Role"
  default     = "bonitasoft-role-assumed"
  type        = string
}