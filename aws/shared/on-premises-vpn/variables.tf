variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "shared"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Shared"
  type        = string
}

variable "existing_transit_gateway_name" {
  description = "Existing Transit Gateway Name"
  default     = "compucom-transit-gateway"
  type        = string
}

variable "existing_transit_gateway_id" {
  description = "Existing Transit Gateway ID"
  default     = "tgw-021d267f84359f0ab"
  type        = string
}

variable "cgw_bgp_asn" {
  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)."
  default     = 65505
  type        = number
}

variable "cgw_ip_address" {
  description = "The IPv4 address for the customer gateway device's outside interface."
  default     = "204.214.150.119"
  type        = string
}