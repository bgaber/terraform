variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "us-prod"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}

variable "configuration_set_name" {
  description = "AWS SES Configuration Set Name"
  default     = "compucom-prod"
  type        = string
}

variable "ses_events" {
  type    = list(string)
  #default = ["send", "reject", "bounce", "delivery", "renderingFailure", "deliveryDelay"]
  default = ["send", "reject", "bounce", "delivery", "renderingFailure"]
  #default = ["send", "reject", "renderingFailure"]
}