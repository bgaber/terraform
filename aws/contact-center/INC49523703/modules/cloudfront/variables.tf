variable "alternate_domain_name" {
  description = "CloudFront Origin Alternate Domain Name"
  type        = string
}

variable "s3_bucket_regional_domain_name" {
  description = "CloudFront Origin Domain Name"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 Bucket ARN"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

variable "cf_dist_comment" {
  description = "Cloudfront Distribution Comment"
  default     = "Used for Contact Center Chat"
  type        = string
}

variable "acm_cert_arn" {
  description = "ACM Certificate ARN"
  default     = "arn:aws:acm:us-east-1:612646292843:certificate/931058a3-2994-4024-a61e-81d5fde9891a"
  type        = string
}