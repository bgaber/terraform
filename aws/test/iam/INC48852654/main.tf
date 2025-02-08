resource "aws_iam_user" "control_m_user" {
  name = var.iam_user_name
}

data "aws_iam_policy_document" "control_m_policy_doc" {
  statement {
    sid       = "ControlMpolicy1"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}"]
  }
  statement {
    sid       = "ControlMpolicy2"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
  }
}

# Provides an IAM inline policy.
resource "aws_iam_user_policy" "control_m_policy" {
  name   = var.iam_policy_name
  user   = aws_iam_user.control_m_user.name
  policy = data.aws_iam_policy_document.control_m_policy_doc.json
}

output "aws_iam_user_arn" {
  value = aws_iam_user.control_m_user.arn
}