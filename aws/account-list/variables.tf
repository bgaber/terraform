variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

# Create a TF_VAR like so:
# export TF_VAR_sso_access_token="<your_access_token>"
variable "sso_access_token" {
  description = "AWS Short Term SSO Access Token"
  type        = string
}