# Added ACM certificate that contains 21 domains required for this CloudFront distribution
# Removed CloudFront Origin Access Identity because it is not required with private S3 bucket
# First working version that works with private S3 bucket

resource "aws_s3_bucket" "go2connect" {
  bucket = var.cf_s3_bucket
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.go2connect.id
  policy = data.aws_iam_policy_document.go2connect.json
}

data "aws_iam_policy_document" "go2connect" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.go2connect.arn}/*"]

    condition {
      test     = "StringEquals"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
      variable = "AWS:SourceArn"
    }
  }
}

locals {
  s3_origin_id = "origin1"
}

resource "aws_cloudfront_origin_access_control" "go2connect" {
  name                              = "go2connect"
  description                       = "go2connect policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  comment = var.cf_dist_comment

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 200
    response_page_path    = "/"
  }
  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true

   origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = aws_s3_bucket.go2connect.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.go2connect.id
    origin_id                = local.s3_origin_id
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    #cloudfront_default_certificate = true
    acm_certificate_arn = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
}

output "aws_s3_bucket_id" {
  value = aws_s3_bucket.go2connect.id
}

output "aws_s3_bucket_arn" {
  value = aws_s3_bucket.go2connect.arn
}

output "aws_cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "aws_cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}

output "aws_cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "aws_cloudfront_distribution_hosted_zone_id" {
  value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}