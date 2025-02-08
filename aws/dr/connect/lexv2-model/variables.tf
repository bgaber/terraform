variable "region" {
  description = "AWS Region"
  default     = "us-west-2"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "us-prod"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}

variable "lex_bot_names" {
  description = "Lex Bot Names"
  type    = list(string)
  default = ["CAMH", "CKE"]
}

variable "lex_role_arn" {
  description = "Lex Bot Role ARN"
  default     = "arn:aws:iam::122639376858:role/aws-service-role/lexv2.amazonaws.com/AWSServiceRoleForLexV2Bots_8ZMPS7M8GAO"
  type        = string
}