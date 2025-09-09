variable "parameters" {
  description = "Parameter Store key/values"
  type = map
  default = {
    "FALCON_CLIENT_ID" = ""
    "FALCON_CLIENT_SECRET" = ""
    "FALCON_HEC_API_KEY_ROUTE_53" = "CannotBeEmpty"
    "FALCON_HEC_API_URL_ROUTE_53" = "CannotBeEmpty"
    "FALCON_HEC_API_KEY_WAF" = "CannotBeEmpty"
    "FALCON_HEC_API_URL_WAF" = "CannotBeEmpty"
    "FALCON_HEC_API_KEY_S3" = "CannotBeEmpty"
    "FALCON_HEC_API_URL_S3" = "CannotBeEmpty"
    "DATADOG_API_KEY" = "CannotBeEmpty"
    "DATADOG_APP_KEY" = "CannotBeEmpty"
    "DATADOG_SITE" = "datadoghq.com"
  }
}