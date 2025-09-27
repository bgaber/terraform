variable "parameters" {
  description = "Parameter Store key/values"
  type = map
  default = {
    "FALCON_CLIENT_ID" = ""
    "FALCON_CLIENT_SECRET" = ""
  }
}