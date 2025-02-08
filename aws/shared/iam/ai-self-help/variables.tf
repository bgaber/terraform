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

variable "iam_group_name" {
  description = "Content Creators Group Name"
  default     = "AI-Self-Help-Content-Creators"
  type        = string
}
variable "assume_role_policy_name" {
  description = "Assume Role Policy"
  default     = "assumerole-ai-chat-content-creators"
  type        = string
}

variable "assumed_role" {
  description = "Switch Role Assumed Role"
  default     = "kendra-lex-role-assumed"
  type        = string
}