variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "service_account" {
  description = "Automated Agent Installation Service Account"
  default     = "automated-agent-installation-sa"
  type        = string
}

variable "iam_policy_name" {
  description = "Automated Agent Installation IAM Policy Name"
  default     = "automated-agent-installation-access"
  type        = string
}

variable "iam_policy_description" {
  description = "Automated Agent Installation IAM Policy Description"
  default     = "Permissions required for Automated Agent Installation"
  type        = string
}

variable "gitlab_repo_name" {
  description = "GitLab Project Name"
  default     = "Automated Agent Installation"
  type        = string
}

variable "gitlab_repo_path" {
  description = "GitLab Project Path"
  default     = "automated-agent-installation"
  type        = string
}

variable "gitlab_repo_description" {
  description = "GitLab Project Description"
  default     = "Automated Agent Installation"
  type        = string
}
