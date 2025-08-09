variable "sqs_queue_name" {
  description = "SQS Queue Name"
  default     = "cloud-custodian"
  type        = string
}

variable "target_aws_accounts" {
  description = "List of AWS account IDs for Cloud Custodian cross-account access"
  type        = list(string)
}