variable "local_region" {
  description = "AWS Region"
  default     = "ca-central-1"
  type        = string
}

variable "canada_cred_profile" {
  description = "AWS Profile"
  default     = "CA-Prod"
  type        = string
}

variable "transit_gateway_id" {
  description = "Transit Gateway Id"
  default     = "tgw-0faab0f773edee0da"
  type        = string
}

variable "direct_connect_name" {
  description = "Direct Connect Name"
  default     = "CANADA PRODUCTION"
  type        = string
}

variable "direct_connect_gw_name" {
  description = "Direct Connect Gateway Name"
  default     = "Canada Direct Connect Gateway"
  type        = string
}