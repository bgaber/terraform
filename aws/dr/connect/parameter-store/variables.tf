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

variable "parameters" {
  description = "Parameter Store key/values"
  type = map
  default = {
    "COGNITO_CLIENT_ID" = ""
    "COGNITO_CLIENT_SECRET" = ""
    "COGNITO_USER_POOL_ID" = "us-west-2_K52tYpb9p"
    "COGNITO_ISSUER" = "https://cognito-idp.us-west-2.amazonaws.com/us-west-2_K52tYpb9p"
    "S3_BUCKET_URL" = "https://s3.us-east-1.amazonaws.com/connect-uat-logos-bucket"
    "S3_BUCKET" = "connect-uat-logos-bucket"
    "CONNECT_TABLE" = "connect-table"
    "NEXTAUTH_SECRET" = "connect"
    "REGION" = "us-west-2"
    "NEXTAUTH_URL" = "https://dr.connect.compucom.com"
    "MULESOFT_HOST" = "https://muleprod.diam.compucom.com/"
    "MULESOFT_KEY" = "="
    "HELP_SEARCH_URL" = "https://compucom.nanorep.co/api/kb/v1/search"
    "HELP_SESSION_URL" = "https://compucom.nanorep.co/api/widget/v1/hello"
    "ARTICLE_URL" = "https://compucom.nanorep.co/api/kb/v1/getArticleData"
    "TWILIO_CHAT_ACCOUNT" = ""
    "TWILIO_CHAT_FLOW" = ""
    "TWILIO_CHAT_STATUS_LINK" = "https://prod.compucomsupport.com/ivrv2/chat/"
    "SERVICENOW_HOST" = "https://iaas.service-now.com"
    "KENDRA_API_VERSION" = "2019-02-03"
    "KENDRA_INDEX_KEY_ID" = ""
    "CHAT_GATEWAY" = "prod.compucomsupport.com"
    "LEX_FLOW_SID" = ""
  }
}