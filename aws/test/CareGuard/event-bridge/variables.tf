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

variable eb_sched_attributes {
  description = "Map of EventBridge Schedule Attributes"
  type = list(object({
    sched_name        = string
    sched_description = string
    lambda_arn        = string
  }))
  default = [
    {
      sched_name        = "careguard-sn-device-update-rule-daily",
      sched_description = "Daily Careguard SN Device Update",
      lambda_arn        = "arn:aws:lambda:us-east-1:300899438431:function:careguard-sn-device-update"
    },
    {
      sched_name        = "careguard-sn-location-update-rule-daily",
      sched_description = "Daily Careguard SN Location Update",
      lambda_arn        = "arn:aws:lambda:us-east-1:300899438431:function:careguard-sn-location-update"
    },
    {
      sched_name        = "careguard-sn-ticket-update-rule-daily",
      sched_description = "Daily Careguard SN Ticket Update",
      lambda_arn        = "arn:aws:lambda:us-east-1:300899438431:function:careguard-sn-ticket-update"
    }
  ]
}