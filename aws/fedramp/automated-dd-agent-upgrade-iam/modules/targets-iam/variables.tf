variable "ddau_name" {
  description = "Automated Datadog Agent Upgrade Name"
  default     = "datadog-agent-upgrade"
  type        = string
}

variable "ddau_iam_policy_name" {
  description = "Automated Datadog Agent Upgrade IAM Policy Name"
  default     = "datadog-agent-upgrade-access"
  type        = string
}

variable "ddau_iam_policy_description" {
  description = "Automated Datadog Agent Upgrade IAM Policy Description"
  default     = "Permissions required for Automated Datadog Agent Upgrade"
  type        = string
}

variable "ddau_iam_role_name" {
  description = "Automated Datadog Agent Upgrade IAM Role Name"
  default     = "datadog-agent-upgrade-role-assumed"
  type        = string
}

# variable "ddau_trusted_role_arn" {
#   description = "Principal Account Automated Datadog Agent Upgrade IAM Role ARN"
#   type        = string
# }

variable "ddau_trusted_user_arn" {
  description = "Principal Account Automated Datadog Agent Upgrade IAM User ARN"
  type        = string
}
