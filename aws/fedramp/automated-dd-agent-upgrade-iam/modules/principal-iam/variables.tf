variable "ddau_name" {
  description = "Automated Datadog Agent Upgrade Name"
  default     = "datadog-agent-upgrade"
  type        = string
}

variable "ddau_service_account" {
  description = "Automated Datadog Agent Upgrade Service Account"
  default     = "datadog-agent-upgrade-sa"
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

variable "ddau_gitlab_repo_id" {
  description = "Automated Datadog Agent Upgrade GitLab Project Id"
  default     = "23007"
  type        = string
}

variable "target_aws_accounts" {
  description = "List of AWS account IDs for IAM cross-account access"
  type        = list(string)
}