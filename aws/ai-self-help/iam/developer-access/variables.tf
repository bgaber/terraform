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

variable "login_account" {
  description = "Requester Account"
  default     = "472510080448"
  type        = string
}

variable "switch_role_profile" {
  description = "AWS Profile"
  default     = "ai-selfhelp"
  type        = string
}

variable "switch_role_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "AI-Self-Help"
  type        = string
}

variable "switch_role_account" {
  description = "Switch Role Account"
  default     = "047453590376"
  type        = string
}

variable "developer_group_name" {
  description = "AI Self Help Developer Group Name"
  default     = "AI-Self-Help-Dev-Group"
  type        = string
}