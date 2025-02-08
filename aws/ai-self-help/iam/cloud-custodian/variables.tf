variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "ai-self-help"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "AI-Self-Help"
  type        = string
}

variable "iam_policy_name" {
  description = "IAM Policy Name"
  default     = "cloud-custodian-tst"
  type        = string
}

variable "iam_policy_description" {
  description = "IAM Policy Description"
  default     = "Permissions required for various Cloud Custodian policies"
  type        = string
}

variable "iam_role_name" {
  description = "IAM Role Name"
  default     = "sre-ec2-role-assumed-tst"
  type        = string
}

variable "iam_role_description" {
  description = "IAM Role Description"
  default     = "Role required for various Cloud Custodian policies"
  type        = string
}

variable "assuming_account" {
  description = "Account that can assume this role"
  default     = "123456789012"
  type        = string
}