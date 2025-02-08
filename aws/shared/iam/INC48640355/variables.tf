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

variable "dev_switch_role_profile" {
  description = "AWS Profile"
  default     = "ai-self-help"
  type        = string
}

variable "dev_switch_role_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "AI-Self-Help"
  type        = string
}

variable user_attributes {
  description = "Map of User attributes"
  type = list(object({
    username  = string
    fullname = string
    email  = string
  }))
  default = [
    {
      username = "jp221316",
      fullname = "Francisco Parra",
      email    = "francisco.parra@compucom.com"
    },
    {
      username = "js222156",
      fullname = "Jorge Soriano",
      email    = "jorge.sorianohernandez@compucom.com"
    }
  ]
}

variable "iam_group_name" {
  description = "Data Engineering Group Name"
  default     = "Data-Engineering"
  type        = string
}

variable "assume_role_policy_name" {
  description = "Assume Role Policy"
  default     = "data-engineering-assume-role-policy"
  type        = string
}

variable "assumed_role" {
  description = "Switch Role Assumed Role"
  default     = "data-engineering-read-only-role-assumed"
  type        = string
}