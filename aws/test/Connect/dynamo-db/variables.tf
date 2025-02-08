variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "profile" {
  description = "AWS Profile"
  default     = "test"
  type        = string
}

variable "cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}

variable "table_name" {
  description = "DynamoDB Table Name"
  default     = "connect-table"
  type        = string
}
