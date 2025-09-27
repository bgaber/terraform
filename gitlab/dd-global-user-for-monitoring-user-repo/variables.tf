variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "service_account" {
  description = "Datadog Global User For Monitoring User Installation Service Account"
  default     = "datadog-global-user-for-monitoring-installation-sa"
  type        = string
}

variable "iam_policy_name" {
  description = "Datadog Global User For Monitoring User Installation IAM Policy Name"
  default     = "datadog-global-user-for-monitoring-installation-access"
  type        = string
}

variable "iam_policy_description" {
  description = "Automated Agent Installation IAM Policy Description"
  default     = "Permissions required for Automated Agent Installation"
  type        = string
}

variable "gitlab_repo_name" {
  description = "GitLab Project Name"
  default     = "Datadog Global User For Monitoring User"
  type        = string
}

variable "gitlab_repo_path" {
  description = "GitLab Project Path"
  default     = "dd-global-user-for-monitoring-user"
  type        = string
}

variable "gitlab_repo_description" {
  description = "GitLab Project Description"
  default     = "Datadog Global User For Monitoring User"
  type        = string
}
