variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
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
  type    = list(string)
  default = ["CAMH", "CKE", "compucom", "Covetrus", "Democonnect", "Epicbrokers", "Firstenergy", "Firstgroup", "HelpatHome", "Holcim", "hub", "IIROC", "knowledge_search_test", "MFDA", "MossAdams", "OrderFlowers", "OthersGeneric", "PMPediatrics", "reuse", "Signet", "Sonic", "USG", "vancouverinternationalairport", "Veolia"]
}