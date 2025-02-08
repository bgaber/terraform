data "aws_caller_identity" "this_account" {}

locals {
    account_id    = data.aws_caller_identity.this_account.account_id
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
      for k,v in var.map_of_strings:
      "arn:aws:firehose:${var.region}:${local.account_id}:deliverystream/exp-mgt-${k}-delivery-stream"
    ]
  }
}

resource "aws_iam_role_policy" "inline_cloudwatch_policy" {
  name   = "Permissions-Policy-For-CWL"
  role   = aws_iam_role.cwl_to_firehose_role.id
  policy = data.aws_iam_policy_document.inline_cloudwatch_policy_doc.json
}

output "cloudwatch_role_arn" {
  value = aws_iam_role.cwl_to_firehose_role.arn
}