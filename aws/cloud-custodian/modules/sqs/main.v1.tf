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
          "arn:aws:iam::${local.account_id}:role/cloud-custodian-role-assumed",
          "arn:aws:iam::502432545091:role/cloud-custodian-role-assumed",
          "arn:aws:iam::413103028457:role/cloud-custodian-role-assumed"
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