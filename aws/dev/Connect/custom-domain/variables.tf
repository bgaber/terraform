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

variable "route53_profile" {
  description = "AWS Profile"
  default     = "shared"
  type        = string
}

variable "route53_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Shared"
  type        = string
}

variable "app_id" {
  description = "Amplify App ID"
  default     = "d1r1hzteelrn91"
  type        = string
}

variable "branches" {
  type = map(string)
  default = {
    #"dev"  = "dev"
    "test" = "test"
    "uat"  = "uat"
    "demo" = "amplify-integration"
  }
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID"
  default     = "Z064264889QSPIPW16Y"
  type        = string
}

variable "cloudfront" {
  description = "Amplify Custom Domain CloudFront"
  default     = "d3e82vdoh5ql16.cloudfront.net"
  type        = string
}