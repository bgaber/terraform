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
  default     = "noc-athena-bucket"
  type        = string
}

variable "s3_results_bucket_name" {
  description = "Destination of Athena Query Output"
  default     = "noc-athena-results-bucket"
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

variable "athena_lambda_role" {
  description = "Athena Lambda IAM ROle"
  default     = "athena_lambda_role"
  type        = string
}

variable "athena_s3_policy" {
  description = "Athena S3 IAM Policy"
  default     = "AthenaS3AccessPolicy"
  type        = string
}

variable "lambda_logging_policy_name" {
  description = "Lambda CloudWatch Log Policy Name"
  default     = "LambdaLoggingPolicy"
  type        = string
}

variable "athena_lambda_name" {
  description = "Lambda Function Name"
  default     = "query-athena-lambda"
  type        = string
}

variable "athena_lambda_archive" {
  description = "Lambda Function Archive"
  default     = "athena_lambda_function.zip"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS Topic ARN"
  type        = string
}