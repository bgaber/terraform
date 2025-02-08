variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "us-dev"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Dev"
  type        = string
}

variable "map_of_strings" {
  description = "Map of Strings"
  type = map
  default = {
    "connect" = "/aws/ecs/connect-cluster-uat"
    "kendra"  = "/aws/lambda/kendra_Search"
    "lex"     = "/connect/lex/Compucom"
    "twilio"  = "/aws/lambda/process-twilio-message"
  }
}