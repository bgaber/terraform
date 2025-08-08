variable "cc_name" {
  description = "Cloud Custodian Name"
  default     = "cloud-custodian"
  type        = string
}

variable "cc_iam_policy_name" {
  description = "Cloud Custodian IAM Policy Name"
  default     = "cloud-custodian-access"
  type        = string
}

variable "cc_iam_policy_description" {
  description = "Cloud Custodian IAM Policy Description"
  default     = "Permissions required for Cloud Custodian"
  type        = string
}

variable "cc_iam_role_name" {
  description = "Cloud Custodian IAM Role Name"
  default     = "cloud-custodian-role-assumed"
  type        = string
}

# variable "cc_trusted_role_arn" {
#   description = "Principal Account Cloud Custodian IAM Role ARN"
#   type        = string
# }

variable "cc_trusted_user_arn" {
  description = "Principal Account Cloud Custodian IAM User ARN"
  type        = string
}
