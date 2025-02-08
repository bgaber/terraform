variable "prod_region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "dr_region" {
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
  default     = "connect-ai-selfhelp-bucket"
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
    "adaptivehospice"               = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/adaptivehospice.xml"
    "camh.ca"                       = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/camh.xml"
    "cioxhealth.com"                = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/CioxFRPROD-1.xml"
    "collegium"                     = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/collegium.xml"
    "collegiumpharma.com"           = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/collegium.xml"
    "compucom"                      = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/compucom.xml"
    "covetrus"                      = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/covetrus.xml"
    "covetrus.com"                  = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/covetrus.xml"
    "epicbrokers"                   = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/epicbrokers.xml"
    "epicbrokers.com"               = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/epicbrokers.xml"
    "firstenergy"                   = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/firstenergy.xml"
    "firstgroup"                    = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/firstgroup.xml"
    "firstgroup.com"                = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/firstgroup.xml"
    "generali.com"                  = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/generaliprodFRi.xml"
    "helpathome.com"                = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/adaptivehospice.xml"
    "holcim"                        = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/holcim.xml"
    "hubinternational"              = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/hubinternational.xml"
    "hubinternational.com"          = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/hubinternational.xml"
    "iiroc"                         = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/iiroc.xml"
    "iiroc.ca"                      = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/iiroc.xml"
    "mossadams"                     = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/mossadams.xml"
    "mossadams.com"                 = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/mossadams.xml"
    "pmpediatrics"                  = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/pmpediatrics.xml"
    "pmpediatrics.com"              = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/pmpediatrics.xml"
    "signet"                        = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/signet.xml"
    "signetjewelers.com"            = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/signet.xml"
    "sonic"                         = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/sonic.xml"
    "sonicautomotive.com"           = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/sonic.xml"
    "suez.com"                      = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/veolia.xml"
    "transdev"                      = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/transdev.xml"
    "transdev.com"                  = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/transdev.xml"
    "usg"                           = "https://lbfrprodam.diam.compucom.com/openam/saml2/jsp/exportmetadata.jsp?entityid=https://lbfrprodam.diam.compucom.com:443/openam/USG&realm=/USG"
    "usg.com"                       = "https://lbfrprodam.diam.compucom.com/openam/saml2/jsp/exportmetadata.jsp?entityid=https://lbfrprodam.diam.compucom.com:443/openam/USG&realm=/USG"
    "veolia"                        = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/veolia.xml"
    "vestis.com"                    = "https://lbfrprodam.diam.compucom.com/openam/saml2/jsp/exportmetadata.jsp?entityid=https://lbfrprodam.diam.compucom.com:443/openam/vestis&realm=/Vestis"
    "yvr"                           = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/yvr.xml"
    "yvr.ca"                        = "https://connect-ai-selfhelp-bucket.s3.amazonaws.com/yvr.xml"
  }
}