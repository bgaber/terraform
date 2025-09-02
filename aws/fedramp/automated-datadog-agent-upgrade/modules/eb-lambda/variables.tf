variable "project_name" {
  description = "Project name used for resource naming"
  default     = "tecsysfed-noc-athena"
  type        = string
}

variable "schedule_name" {
  description = "Poll Agent Version Schedule Name"
  default     = "poll-agent-version"
  type        = string
}

variable "schedule_description" {
  description = "Poll Agent Version Schedule Description"
  default     = "Poll Agent Version"
  type        = string
}

variable "s3_source_bucket_name" {
  description = "Source of CSV file"
  default     = "tecsysfed-noc-athena-bucket"
  type        = string
}

variable "s3_results_bucket_name" {
  description = "Destination of Athena Query Output"
  default     = "tecsysfed-noc-athena-results-bucket"
  type        = string
}

variable "athena_prefix" {
  description = "Athena Prefix"
  default     = "data"
  type        = string
}

variable "athena_csv_key" {
  description = "Athena CSV Key"
  default     = "version-approvals.csv"
  type        = string
}

variable "database_name" {
  description = "Athena Database Name"
  default     = "agent_version_database"
  type        = string
}

variable "athena_table" {
  description = "Athena Database Table"
  default     = "agent_version_table"
  type        = string
}

variable "lambda_role_name" {
  description = "FedRAMP SSM IAM Role"
  type        = string
}

variable "lambda_policy_name" {
  description = "FedRAMP SSM IAM Policy"
  type        = string
}

variable "lambda_iam_assume_role_name" {
  description = "The IAM Role that is assumed by the Lambda function in other accounts"
  type        = string
}

variable "lambda_logging_policy_name" {
  description = "Lambda CloudWatch Log Policy Name"
  default     = "TecsysFedLambdaLoggingPolicy"
  type        = string
}

variable "automated_agent_installation_lambda_name" {
  description = "Lambda Function Name"
  default     = "automated-datadog-agent-upgrade"
  type        = string
}

variable "athena_lambda_archive" {
  description = "Lambda Function Archive"
  default     = "athena_lambda_function.zip"
  type        = string
}

variable "linux_ssm_document_name" {
  description = "Linux SSM Document Name"
  type        = string
}

variable "linux_ssm_document_arn" {
  description = "Linux SSM Document ARN"
  type        = string
}

variable "windows_ssm_document_name" {
  description = "Windows SSM Document Name"
  type        = string
}

variable "windows_ssm_document_arn" {
  description = "Windows SSM Document ARN"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS Topic ARN"
  type        = string
}
