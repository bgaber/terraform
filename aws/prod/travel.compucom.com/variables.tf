variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
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

variable "cf_s3_bucket" {
  description = "CloudFront S3 Bucket"
  default     = "travel.compucom.com"
  type        = string
}

variable "s3_redirect_destination" {
  description = "S3 Redirect Destination"
  default     = "app.navan.com/app/user2/"
  type        = string
}

variable "cf_dist_comment" {
  description = "Cloudfront Distribution Comment"
  default     = "Compucom travel website"
  type        = string
}

variable "alt_domain_names" {
  description = "Alternate domain names"
  type        = list(string)
  default     = ["travel.compucom.com"]
}

variable "acm_cert_arn" {
  description = "ACM Certificate ARN"
  default     = "arn:aws:acm:us-east-1:122639376858:certificate/d8df5b92-15ab-41b4-a25e-15a1159e4142"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID"
  default     = "Z064264889QSPIPW16Y"
  type        = string
}