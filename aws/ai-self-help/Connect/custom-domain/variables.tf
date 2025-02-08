variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "profile" {
  description = "AWS Profile"
  default     = "ai-self-help"
  type        = string
}

variable "cred_profile" {
  description = "AWS Credential File Profile"
  default     = "AI-Self-Help"
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
  default     = "d5ngqqzeoql1z"
  type        = string
}

variable "branches" {
  type = map(string)
  default = {
    "dev"  = "dev"
    "test" = "test"
    "uat"  = "uat"
  }
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID"
  default     = "Z064264889QSPIPW16Y"
  type        = string
}

variable "cloudfront" {
  description = "Amplify Custom Domain CloudFront"
  default     = "d2ydekvvb5wcp2.cloudfront.net"
  type        = string
}