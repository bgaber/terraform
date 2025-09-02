variable "linux_ssm_document_name" {
  description = "Linux SSM Document Name"
  type        = string
}

variable "windows_ssm_document_name" {
  description = "Windows SSM Document Name"
  type        = string
}

variable "s3_output_location" {
  description = "S3 Bucket Log Output Location"
  type        = string
  default     = "tecsysfed-noc-datadog-agent-install-logs"
}

variable "action" {
  description = "Install or Upgrade the Datadog Agent"
  type        = string
  default     = "Install"
}

variable "agentmajorversion" {
  description = "Datadog Agent Major Version"
  type        = string
  default     = "7"
}

variable "agentminorversion" {
  description = "Datadog Agent Minor Version"
  type        = string
  default     = "66.1"
}
