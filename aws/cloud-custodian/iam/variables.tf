variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "cc_name" {
  description = "Cloud Custodian Name"
  default     = "cloud-custodian"
  type        = string
}

variable "cc_mailer_service_account" {
  description = "Cloud Custodian Mailer Service Account"
  default     = "cloud-custodian-mailer-sa"
  type        = string
}

variable "cc_mailer_iam_policy_name" {
  description = "Cloud Custodian Mailer IAM Policy Name"
  default     = "cloud-custodian-mailer-access"
  type        = string
}

variable "cc_mailer_iam_policy_description" {
  description = "Cloud Custodian Mailer IAM Policy Description"
  default     = "Permissions required for Cloud Custodian Mailer"
  type        = string
}

# Must match role name in the mailer.yml
variable "cc_mailer_iam_role_name" {
  description = "Cloud Custodian Mailer IAM Role Name"
  default     = "cloud-custodian-mailer"
  type        = string
}

variable "cc_service_account" {
  description = "Cloud Custodian Service Account"
  default     = "cloud-custodian-sa"
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

variable "sqs_iam_policy_name" {
  description = "Cloud Custodian SQS IAM Policy Name"
  default     = "cloud-custodian-sqs-access"
  type        = string
}

variable "sqs_iam_policy_description" {
  description = "Cloud Custodian SQS IAM Policy Description"
  default     = "Permissions required for Cloud Custodian SQS actions"
  type        = string
}

variable "cc_mailer_gitlab_repo_id" {
  description = "Cloud Custodian Mailer Mailer GitLab Project Id"
  default     = "23009"
  type        = string
}

variable "cc_gitlab_repo_id" {
  description = "Cloud Custodian GitLab Project Id"
  default     = "23007"
  type        = string
}