data "aws_caller_identity" "this_account" {}

locals {
    account_id    = data.aws_caller_identity.this_account.account_id
}


resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose_stream" {
  for_each      = var.prefix_log_group
  name        = "exp-mgt-${each.key}-delivery-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = "arn:aws:s3:::${var.s3_bucket_name}"
    buffering_size     = 5
    compression_format = var.s3_compression_format
    prefix             = "${each.key}/"

    # processing_configuration {
    #   enabled = "true"

    #   # New line delimiter processor
    #   processors {
    #     type = "AppendDelimiterToRecord"
    #   }
    # }
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "FirehosetoS3Role"

  # Trusted entities
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Principal": {
           "Service": "firehose.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "inline_firehose_role_policy" {
  name = "Permissions-Policy-For-Firehose"
  role = aws_iam_role.firehose_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "S3Access",
        Effect = "Allow",
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "cwl_to_firehose_role" {
  name = "CWLtoKinesisFirehoseRole"

  # Trusted entities
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Principal": {
           "Service": "logs.${var.region}.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

data "aws_iam_policy_document" "inline_cloudwatch_policy_doc" {
  statement {
    sid = "FirehoseAccess1"
    effect = "Allow"
    actions = [
      "firehose:ListDeliveryStreams",
    ]
    resources = [
      "*",
    ]
  }

  statement {
    sid = "Passrole"
    effect = "Allow"
    actions = [
      "iam:PassRole",
    ]
    resources = [
      aws_iam_role.cwl_to_firehose_role.arn,
    ]
  }

  statement {
    sid = "FirehoseAccess2"
    effect = "Allow"
    actions = [
      "firehose:DescribeDeliveryStream",
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]

    resources = [
      for k,v in var.prefix_log_group:
      "arn:aws:firehose:${var.region}:${local.account_id}:deliverystream/exp-mgt-${k}-delivery-stream"
    ]
  }
}

resource "aws_iam_role_policy" "inline_cloudwatch_policy" {
  name   = "Permissions-Policy-For-CWL"
  role   = aws_iam_role.cwl_to_firehose_role.id
  policy = data.aws_iam_policy_document.inline_cloudwatch_policy_doc.json
}

resource "aws_cloudwatch_log_subscription_filter" "subscription_filter" {
  for_each        = var.prefix_log_group
  name            = "AllTraffic"
  role_arn        = aws_iam_role.cwl_to_firehose_role.arn
  log_group_name  = each.value
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.kinesis_firehose_stream[each.key].arn
}

output "firehose_role_arn" {
  value = aws_iam_role.cwl_to_firehose_role.arn
}

output "cloudwatch_role_arn" {
  value = aws_iam_role.cwl_to_firehose_role.arn
}

output "kinesis_firehoses_arn" {
  value = values(aws_kinesis_firehose_delivery_stream.kinesis_firehose_stream)[*].arn
}