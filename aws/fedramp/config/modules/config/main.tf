data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Get AWS account of the current profile
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

# Configuration Recorder
resource "aws_config_configuration_recorder" "fedramp" {
  name     = "fedramp"
  role_arn = "arn:aws:iam::${local.account_id}:role/aws-service-role/config.amazonaws.com/${var.aws_service_role_for_config}"

  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

# Delivery Channel
resource "aws_config_delivery_channel" "fedramp" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket
  depends_on     = [aws_config_configuration_recorder.fedramp]
}

resource "aws_s3_bucket" "config_bucket" {
  bucket        = "config-bucket-${local.account_id}-${data.aws_region.current.name}"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "config_bucket_policy" {
  bucket = aws_s3_bucket.config_bucket.id
  policy = data.aws_iam_policy_document.aws_config_s3_bucket_policy.json
}

data "aws_iam_policy_document" "aws_config_s3_bucket_policy" {
  statement {
    sid     = "AWSConfigBucketPermissionsCheck"
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.config_bucket.arn]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [local.account_id]
    }
  }

  statement {
    sid     = "AWSConfigBucketExistenceCheck"
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.config_bucket.arn]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [local.account_id]
    }
  }

  statement {
    sid     = "AWSConfigBucketDelivery"
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.config_bucket.arn}/AWSLogs/${local.account_id}/Config/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [local.account_id]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_config_conformance_pack" "fedramp_moderate" {
  name = "FedRAMP-Moderate-Operational-Best-Practices"

  delivery_s3_bucket = aws_s3_bucket.config_bucket.bucket

  template_body = file("${path.module}/templates/Operational-Best-Practices-for-FedRAMP.yaml")

  depends_on = [
    aws_config_configuration_recorder_status.recorder_status
  ]
}


# Start the recorder
resource "aws_config_configuration_recorder_status" "recorder_status" {
  name       = aws_config_configuration_recorder.fedramp.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.fedramp]
}

output "aws_config_configuration_recorder_id" {
  value = aws_config_configuration_recorder.fedramp.id
}

output "aws_config_delivery_channel_id" {
  value = aws_config_delivery_channel.fedramp.id
}

output "fedramp_moderate_conformance_pack_id" {
  value = aws_config_conformance_pack.fedramp_moderate.id
}