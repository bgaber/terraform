data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_sqs_queue" "custodian_queue" {
  name = var.sqs_queue_name
}

resource "aws_sqs_queue_policy" "custodian_queue" {
  queue_url = aws_sqs_queue.custodian_queue.id

  policy = jsonencode({
    Version = "2012-10-17" # !! Important !!
    Statement = [{
      Sid    = "CloudCustodianSQSAccessPolicy"
      Effect = "Allow"
      Principal = {
        AWS: [
          "arn:aws:iam::${local.account_id}:root",
          "arn:aws:iam::438979369891:root",
          "arn:aws:iam::686255941416:root",
          "arn:aws:iam::311141548321:root",
          "arn:aws:iam::528757785295:root",
          "arn:aws:iam::054037137415:root",
          "arn:aws:iam::202533508444:root",
          "arn:aws:iam::816069130447:root",
          "arn:aws:iam::548813917035:root",
          "arn:aws:iam::445567083790:root",
          "arn:aws:iam::104299473261:root",
          "arn:aws:iam::980921753767:root",
          "arn:aws:iam::897722679597:root",
          "arn:aws:iam::195665324256:root"
        ]
      }
      Action   = "SQS:*"
      Resource = aws_sqs_queue.custodian_queue.arn
    }]
  })
}

output "sqs_arn" {
  value = aws_sqs_queue.custodian_queue.arn
}