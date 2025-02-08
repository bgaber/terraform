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

variable "s3_bucket" {
  description = "S3 Bucket"
  default     = "fsl-salesforce"
  type        = string
}

variable "iam_group_name" {
  description = "IAM Group Name"
  default     = "Salesforce"
  type        = string
}
variable "assume_role_policy_name" {
  description = "Assume Role Policy"
  default     = "assumerole-salesforce"
  type        = string
}

variable "assumed_role" {
  description = "Switch Role Assumed Role"
  default     = "salesforce-role-assumed"
  type        = string
}