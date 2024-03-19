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

variable "lex_bot_names_old" {
  type    = list(string)
  default = ["camh", "cke", "collegium", "compucom", "covetrus", "democonnect", "epicbrokers", "firstenergy", "firstgroup", "generali", "helpathome", "holcim", "hub", "iiroc", "mfda", "mossadams", "othersgeneric", "pmpediatrics", "reuse", "signet", "sonic", "transdev", "usg", "vancouverinternationalairport", "veolia"]
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
    "generali"                      = "Generali"
    "helpathome"                    = "HelpatHome"
    "holcim"                        = "Holcim"
    "hub"                           = "hub"
    "iiroc"                         = "IIROC"
    "mfda"                          = "MFDA"
    "mossadams"                     = "MossAdams"
    "othersgeneric"                 = "OthersGeneric"
    "pmpediatrics"                  = "PMPediatrics"
    "reuse"                         = "reuse"
    "signet"                        = "Signet"
    "sonic"                         = "Sonic"
    "transdev"                      = "Transdev"
    "usg"                           = "USG"
    "vancouverinternationalairport" = "vancouverinternationalairport"
    "veolia"                        = "Veolia"
  }
}

variable "s3_bucket" {
  description = "Lambda Function Name"
  default     = "connect-dr-iac-bucket"
  type        = string
}

variable "lambda_deployment_pkg" {
  description = "Lambda Deployment Package"
  default     = "compucom-router-130b724d-df8a-4642-9563-9fc82dba51f6.zip"
  type        = string
}

variable "lex_bot_alias_arn" {
  description = "Lex Bot Alias ARN"
  default     = "arn:aws:lex:us-west-2:122639376858:bot-alias/OWGCYIRCOS/TSTALIASID"
  type        = string
}