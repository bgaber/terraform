variable "region" {
  description = "AWS Region"
  default     = "us-west-2"
  type        = string
}

variable "table_name" {
  description = "DynamoDB Table Name"
  default     = "connect-table"
  type        = string
}

variable "mulesoft_host" {
  description = "MuleSoft Host"
  default     = "https://muleprod.diam.compucom.com/"
  type        = string
}

variable "mulesoft_key" {
  description = "MuleSoft Key"
  default     = "MWZkMTQ5YjA4ZGFjNDMyNThhNGMyOWM0YzEyMTc2MGM6MjIxYjYxQzY1MGRiNDFiM0FFYmY4MGY4QTBmYjBiMkE"
  type        = string
}

variable "mulesoft_table" {
  description = "MuleSoft Table"
  default     = "connect-table"
  type        = string
}

variable "s3_bucket" {
  description = "Lambda Bucket Name"
  default     = "connect-dr-iac-bucket"
  type        = string
}

variable "lambda_layer_pkg" {
  description = "Lambda Layer Package"
  default     = "359acbd7fa52dfa563bd0fe011162758344b40acbf3b68983ac07daf49f4d200.zip"
  type        = string
}

variable "ptg_lambda_deployment_pkg" {
  description = "Pre-Token Generator Lambda Deployment Package"
  default     = "a1d68f32bbede4bef55791a3e9d7d37fcbde35ff61fd6ad8a74bec2d9c8bfcdc.zip"
  type        = string
}

variable "custom_lambda_deployment_pkg" {
  description = "For Custom::DescribeCognitoUserPoolClient"
  default     = "f9346b940b724b094a16ca051c017799995fa93df6da38a0539bf7c000fee50a.zip"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda Function Name"
  default     = "connect-prod-pre-token-generator"
  type        = string
}

variable "lambda_function_description" {
  description = "Lambda Function Description"
  default     = "the connect pre-token-generator lambda"
  type        = string
}

variable "lambda_function_role" {
  description = "Lambda Function Execution Role"
  default     = "connect-prod-pre-token-generator-role"
  type        = string
}

variable "idp_saml_names_old" {
  type    = list(string)
  default = ["adaptivehospice", "camh", "collegium", "compucom", "covetrus", "epicbrokers", "firstenergy", "firstgroup", "holcim", "hubinternational", "iiroc", "mossadams", "pmpediatrics", "signet", "sonic", "transdev", "usg", "veolia", "yvr"]
}

variable "idp_saml_names" {
  description = "IdP SAML Names"
  type = map
  default = {
    "adaptivehospice"               = "adaptivehospice"
    "camh.ca"                       = "camh"
    "cioxhealth.com"                = "CioxFRPROD-1"
    "collegium"                     = "collegium"
    "collegiumpharma.com"           = "collegium"
    "compucom"                      = "compucom"
    "covetrus"                      = "covetrus"
    "covetrus.com"                  = "covetrus"
    "epicbrokers"                   = "epicbrokers"
    "epicbrokers.com"               = "epicbrokers"
  #  "firstenergy"                   = "firstenergy"
    "firstgroup"                    = "firstgroup"
    "firstgroup.com"                = "firstgroup"
    "generali.com"                  = "generaliprodFRi"
    "helpathome.com"                = "adaptivehospice"
    "holcim"                        = "holcim"
    "hubinternational"              = "hubinternational"
    "hubinternational.com"          = "hubinternational"
    "iiroc"                         = "iiroc"
    "iiroc.ca"                      = "iiroc"
    "mossadams"                     = "mossadams"
    "mossadams.com"                 = "mossadams"
    "pmpediatrics"                  = "pmpediatrics"
    "pmpediatrics.com"              = "pmpediatrics"
    "signet"                        = "signet"
    "signetjewelers.com"            = "signet"
    "sonic"                         = "sonic"
    "sonicautomotive.com"           = "sonic"
    "suez.com"                      = "veolia"
    "transdev"                      = "transdev"
    "transdev.com"                  = "transdev"
    "usg"                           = "usg"
    "veolia"                        = "veolia"
    "yvr"                           = "yvr"
    "yvr.ca"                        = "yvr"
  }
}