variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "sns_topic" {
  description = "SNS Topic"
  default     = "noc-agent-validation-notification"
  type        = string
}