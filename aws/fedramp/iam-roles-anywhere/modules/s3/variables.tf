variable "trust_anchor_name" {
  description = "AWS IAM Roles Anywhere Trust Anchor Name"
  default     = "falcon-s3-trust-anchor"
  type        = string
}

variable "roles_anywhere_profile_name" {
  description = "AWS IAM Roles Anywhere Profile Name"
  default     = "falcon-s3-profile"
  type        = string
}

variable "iam_role_name" {
  description = "AWS IAM Role Name"
  default     = "falcon-s3-role"
  type        = string
}