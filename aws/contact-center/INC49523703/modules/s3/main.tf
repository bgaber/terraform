resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.s3_bucket_name}"
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Post CloudFront
resource "aws_s3_bucket_acl" "s3_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket]

  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Policy before CloudFront
# Now moved to the CloudFront module
#
# resource "aws_s3_bucket_policy" "chat_bucket_policy" {
#   bucket = aws_s3_bucket.s3_bucket.id
#   #policy = data.aws_iam_policy_document.chat.json
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid" : "AllowPublicRead",
#         "Effect" : "Allow",
#         "Principal" : "*",
#         "Action" : "s3:GetObject",
#         "Resource" : "${aws_s3_bucket.s3_bucket.arn}/*"
#       }
#     ]
#   })
# }

# data "aws_iam_policy_document" "chat" {
#   statement {
#     actions = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]
#     principals {
# 	    type = "*"
# 	    identifiers = ["*"]
# 	  }
#   }
# }

resource "aws_s3_bucket_website_configuration" "chat" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }
}

output "s3_bucket_id" {
  value = aws_s3_bucket.s3_bucket.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

output "s3_bucket_regional_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
}

output "s3_website_domain" {
  value = aws_s3_bucket_website_configuration.chat.website_domain
}

output "s3_website_endpoint" {
  value = aws_s3_bucket_website_configuration.chat.website_endpoint
}