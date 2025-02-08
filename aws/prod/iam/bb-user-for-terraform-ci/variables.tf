variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "us-prod"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}

variable "switch_role_profile" {
  description = "AWS Profile"
  default     = "shared"
  type        = string
}

variable "switch_role_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Shared"
  type        = string
}

variable "iam_user_name" {
  description = "IAM User Name"
  default     = "terraform_ci_for_bitbucket"
  type        = string
}

variable "assume_role_policy_name" {
  description = "Assume Role Policy"
  default     = "AssumeTerraformBitbucketRole"
  type        = string
}
variable "assumed_role" {
  description = "Switch Role Assumed Role"
  default     = "terraform-ci-for-bitbucket-role-assumed"
  type        = string
}