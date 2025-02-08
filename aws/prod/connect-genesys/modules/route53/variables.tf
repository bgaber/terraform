variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID"
  default     = "Z064264889QSPIPW16Y"
  type        = string
}

variable "prod_record_name" {
  description = "Route 53 Prod Record Name"
  default     = "translate.connect.compucom.com"
  type        = string
}

variable "prod_record_value" {
  description = "Route 53 Prod Record Value"
  type        = string
}

variable "uat_record_name" {
  description = "Route 53 UAT Record Name"
  default     = "translatetest.connect.compucom.com"
  type        = string
}

variable "uat_record_value" {
  description = "Route 53 UAT Record Value"
  default     = "genesys-chat-translator-lb-uat-1607458422.us-east-1.elb.amazonaws.com"
  type        = string
}