locals {
  s3_origin_id = "origin1"
}

resource "aws_cloudfront_origin_access_control" "chat" {
  name                              = "chat"
  description                       = "chat policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  comment = var.cf_dist_comment
  aliases = ["${var.alternate_domain_name}"]

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
    domain_name              = var.s3_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.chat.id
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
    acm_certificate_arn = var.acm_cert_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
}

data "aws_iam_policy_document" "chat_bucket_policy" {
  statement {
    sid = "CloudFrontAccess"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["${var.s3_bucket_arn}/*"]

    condition {
      test     = "StringEquals"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
      variable = "AWS:SourceArn"
    }
  }
  
  statement {
    sid = "BitbucketAccess"

    principals {
	    type = "*"
	    identifiers = ["*"]
	  }

    actions   = ["s3:PutObject", "s3:PutObjectAcl", "s3:GetObject", "s3:ListBucket", "s3:DeleteObject"]
    
    resources = ["${var.s3_bucket_arn}/*", "${var.s3_bucket_arn}"]
    condition {
      test     = "ForAnyValue:IpAddress"
      values   = ["34.199.54.113/32",
            "34.232.25.90/32",
            "34.232.119.183/32",
            "34.236.25.177/32",
            "35.171.175.212/32",
            "52.54.90.98/32",
            "52.202.195.162/32",
            "52.203.14.55/32",
            "52.204.96.37/32",
            "34.218.156.209/32",
            "34.218.168.212/32",
            "52.41.219.63/32",
            "35.155.178.254/32",
            "35.160.177.10/32",
            "34.216.18.129/32",
            "3.216.235.48/32",
            "34.231.96.243/32",
            "44.199.3.254/32",
            "174.129.205.191/32",
            "44.199.127.226/32",
            "44.199.45.64/32",
            "3.221.151.112/32",
            "52.205.184.192/32",
            "52.72.137.240/32"]
      variable = "AWS:SourceIp"
    }
  }
}

resource "aws_s3_bucket_policy" "chat_bucket_policy" {
  bucket = var.s3_bucket_name
  policy = data.aws_iam_policy_document.chat_bucket_policy.json
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