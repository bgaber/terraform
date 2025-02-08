resource "aws_s3_bucket" "cf_s3_bucket" {
  bucket = var.cf_s3_bucket
}

resource "aws_s3_bucket_website_configuration" "cf_s3_bucket" {
  bucket = aws_s3_bucket.cf_s3_bucket.id

 redirect_all_requests_to {
  host_name = var.s3_redirect_destination
  protocol = "https"
  }
}

resource "aws_s3_bucket_policy" "allow_read_access_from_cloudfront_dist" {
  bucket = aws_s3_bucket.cf_s3_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.cf_s3_bucket.arn}/*"]

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

resource "aws_cloudfront_distribution" "s3_distribution" {
  comment = var.cf_dist_comment
  aliases = var.alt_domain_names

  # custom_error_response {
  #   error_caching_min_ttl = 300
  #   error_code            = 403
  #   response_code         = 200
  #   response_page_path    = "/"
  # }
  # custom_error_response {
  #   error_caching_min_ttl = 300
  #   error_code            = 404
  #   response_code         = 200
  #   response_page_path    = "/index.html"
  # }

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
  is_ipv6_enabled     = false

   origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = aws_s3_bucket_website_configuration.cf_s3_bucket.website_endpoint
    origin_id                = local.s3_origin_id
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    #cloudfront_default_certificate = true
    acm_certificate_arn = var.acm_cert_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
}

resource "aws_route53_record" "cf_dns_record" {
  provider = aws.route53
  zone_id  = var.hosted_zone_id
  name     = var.cf_s3_bucket
  ttl      = 300
  type     = "CNAME"
  records  = [aws_cloudfront_distribution.s3_distribution.domain_name]
}

output "aws_s3_bucket_id" {
  value = aws_s3_bucket.cf_s3_bucket.id
}

output "aws_s3_bucket_arn" {
  value = aws_s3_bucket.cf_s3_bucket.arn
}

output "aws_s3_bucket_regional_domain_name" {
  value = aws_s3_bucket.cf_s3_bucket.bucket_regional_domain_name
}

output "aws_s3_bucket_website_domain" {
  value = aws_s3_bucket_website_configuration.cf_s3_bucket.website_domain
}

output "aws_s3_bucket_website_endpoint" {
  value = aws_s3_bucket_website_configuration.cf_s3_bucket.website_endpoint
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