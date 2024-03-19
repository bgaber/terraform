variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "requester_profile" {
  description = "AWS Profile"
  default     = "sandbox"
  type        = string
}

variable "requester_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Sandbox"
  type        = string
}

variable "requester_account" {
  description = "Requester Account"
  default     = "655690556973"
  type        = string
}

variable "requester_vpc_id" {
  description = "Requester VPC Id"
  default     = "vpc-1234567"
  type        = string
}

variable "accepter_profile" {
  description = "AWS Profile"
  default     = "shared"
  type        = string
}

variable "accepter_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "default0"
  type        = string
}

variable "accepter_account" {
  description = "Accepter Account"
  default     = "472510080448"
  type        = string
}

variable "accepter_vpc_id" {
  description = "Accepter VPC Id"
  default     = "vpc-25fb4742"
  type        = string
}