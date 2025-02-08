resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.s3_bucket_name}-${terraform.workspace}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_iam_policy" "bucket_policy" {
  name        = "snowflake-s3-${var.s3_bucket_name}-${terraform.workspace}-bucket-policy"
  description = "${var.iam_policy_description} ${var.s3_bucket_name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion"
        ],
        "Resource": "arn:aws:s3:::${var.s3_bucket_name}-${terraform.workspace}/*"
      },
      {
        "Effect": "Allow",
        "Action": [
            "s3:ListBucket",
            "s3:GetBucketLocation"
        ],
        "Resource": "arn:aws:s3:::${var.s3_bucket_name}-${terraform.workspace}",
        "Condition": {
            "StringLike": {
                "s3:prefix": [
                    "*"
                ]
            }
        }
      },
      {
        "Sid": "AllowUseOfTheKey",
        "Effect": "Allow",
        "Action": "kms:Decrypt",
        "Resource": "*"
      }
    ]
}
EOF
}

resource "aws_iam_role" "s3_role" {
  name = "snowflake-s3-${var.s3_bucket_name}-${terraform.workspace}-bucket-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_account_arn
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.trusted_external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_role_attachment" {
  policy_arn = aws_iam_policy.bucket_policy.arn
  role       = aws_iam_role.s3_role.name
}