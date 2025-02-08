variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "us-test"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}

variable "schedule_name" {
  description = "EventBridge Schedule Name"
  default     = "careguard-sn-location-update-rule-daily"
  type        = string
}

variable "schedule_description" {
  description = "EventBridge Schedule Description"
  default     = "Daily Careguard SN Location Update"
  type        = string
}

variable "lambda_arn" {
  description = "Lambda function ARN"
  default     = "arn:aws:lambda:us-east-1:300899438431:function:careguard-sn-location-update"
  type        = string
}