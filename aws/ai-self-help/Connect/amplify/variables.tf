variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "profile" {
  description = "AWS Profile"
  default     = "dev"
  type        = string
}

variable "cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Dev"
  type        = string
}

# https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/integrate-a-bitbucket-repository-with-aws-amplify-using-aws-cloudformation.html
# curl -X POST -u "KEY:SECRET" https://bitbucket.org/site/oauth2/access_token -d grant_type=client_credentials
variable "bb_oath_token" {
  description = "Bitbucket OAuth Token"
  type        = string
}

variable "app_name" {
  description = "Amplify App Name"
  default     = "connect-dev"
  type        = string
}