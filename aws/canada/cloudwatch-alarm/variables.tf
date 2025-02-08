variable "region" {
  description = "AWS Region"
  default     = "ca-central-1"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "CA-Prod"
  type        = string
}

variable "alarm_name" {
  description = "US Shared VPC CIDRs"
  default     = "bonitasoft-rds-low-free-disk-space"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS Topic ARN"
  default     = "arn:aws:sns:ca-central-1:172507017890:cloud-ops-notifications"
  type        = string
}

variable "rds_db_name" {
  description = "RDS Database Name"
  default     = "bonitasoft-prod"
  type        = string
}