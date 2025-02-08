resource "aws_iam_user" "bitbucket_user" {
  name = var.iam_user_name
}

resource "aws_iam_policy" "bucket_policy" {
  name        = "${var.s3_bucket_name}-bucket-policy"
  description = "${var.iam_policy_description} ${var.s3_bucket_name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject"
        ],
        "Resource": [
          "arn:aws:s3:::${var.s3_bucket_name}/*",
          "arn:aws:s3:::${var.s3_bucket_name}"
        ]
      }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "s3_role_attachment" {
  policy_arn = aws_iam_policy.bucket_policy.arn
  user       = aws_iam_user.bitbucket_user.name
}

output "bitbucket_user_arn" {
  value = aws_iam_user.bitbucket_user.arn
}