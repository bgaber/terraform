variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID"
  default     = "Z16UPKBS37KBRS"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront Domain Name"
  type        = string
}