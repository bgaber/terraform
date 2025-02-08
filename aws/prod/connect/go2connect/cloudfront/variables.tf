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

variable "cf_s3_bucket" {
  description = "CloudFront S3 Bucket"
  default     = "cc-connect-spa"
  type        = string
}

variable "cf_dist_comment" {
  description = "Cloudfront Distribution Comment"
  default     = "Used for Go2Connect Prod"
  type        = string
}

variable "acm_cert_arn" {
  description = "ACM Certificate ARN"
  default     = "arn:aws:acm:us-east-1:122639376858:certificate/b88017b3-5e0a-4b79-a865-1b50fec1ddd4"
  type        = string
}