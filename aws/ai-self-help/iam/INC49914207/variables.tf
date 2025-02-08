variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "ai-self-help"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "AI-Self-Help"
  type        = string
}

variable "iam_user_name" {
  description = "IAM User Name"
  default     = "sa-bitbucket-teamsapp"
  type        = string
}