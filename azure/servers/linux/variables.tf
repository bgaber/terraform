variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group" {
  type        = string
  default     = "cc-vnethub-eastus"
  description = "Name of resource group."
}

variable "vnet_name" {
  type        = string
  default     = "cc-hub-eastus"
  description = "Name of Virtual Network."
}

variable "subnet_name" {
  type        = string
  default     = "PrivateB"
  description = "Name of subnet."
}

variable "server_name" {
  type        = string
  default     = "Demo-VM"
  description = "Server Name."
}