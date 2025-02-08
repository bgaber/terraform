variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "profile" {
  description = "AWS Profile"
  default     = "test"
  type        = string
}

variable "cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}

# https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/integrate-a-bitbucket-repository-with-aws-amplify-using-aws-cloudformation.html
# curl -X POST -u "KEY:SECRET" https://bitbucket.org/site/oauth2/access_token -d grant_type=client_credentials
variable "bb_oath_token" {
  description = "Bitbucket OAuth Token"
  default     = "VfYjjPstFGUS2rf7JIClkhdAMAR8EkYRBuNnB_Tjg2ukf_lXCO0qd7wigl-OVahXyuC5Hi9AvZhOFlGI1zEFlacsUNM="
  type        = string
}