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