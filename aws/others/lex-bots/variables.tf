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

variable "lex_bot_name" {
  description = "Lex Bot Name"
  default     = "compucom"
  type        = string
}

variable "lex_bot_alias" {
  description = "Lex Bot Alias"
  default     = "ProdBotAlias"
  type        = string
}

variable "lex_bot_names_old" {
  type    = list(string)
  default = ["camh", "cke", "collegium", "compucom", "covetrus", "democonnect", "epicbrokers", "firstenergy", "firstgroup", "helpathome", "holcim", "hub", "iiroc", "knowledge_search_test", "mfda", "mossadams", "orderflowers", "othersgeneric", "pmpediatrics", "reuse", "sonic", "usg", "vancouverinternationalairport", "veolia", "transdev", "generali"]
}

variable "lex_bot_names" {
  description = "Lex Bot Names"
  type = map
  default = {
    "camh"                          = "CAMH"
    "cke"                           = "CKE"
    "collegium"                     = "Collegium"
    "compucom"                      = "compucom"
    "covetrus"                      = "Covetrus"
    "democonnect"                   = "DemoConnect"
    "epicbrokers"                   = "EpicBrokers"
    "firstenergy"                   = "FirstEnergy"
    "firstgroup"                    = "FirstGroup"
    "helpathome"                    = "HelpatHome"
    "holcim"                        = "Holcim"
    "hub"                           = "hub"
    "iiroc"                         = "IIROC"
    "knowledge_search_test"         = "knowledge_search_test"
    "mfda"                          = "MFDA"
    "mossadams"                     = "MossAdams"
    "orderflowers"                  = "orderflowers"
    "othersgeneric"                 = "OthersGeneric"
    "pmpediatrics"                  = "PMPediatrics"
    "reuse"                         = "reuse"
    "sonic"                         = "Sonic"
    "usg"                           = "USG"
    "vancouverinternationalairport" = "vancouverinternationalairport"
    "veolia"                        = "Veolia"
    "transdev"                      = "Transdev"
    "generali"                      = "Generali"
  }
}