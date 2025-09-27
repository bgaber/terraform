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
          "arn:aws:iam::438979369891:role/cloud-custodian-role-assumed",
          "arn:aws:iam::686255941416:role/cloud-custodian-role-assumed",
          "arn:aws:iam::311141548321:role/cloud-custodian-role-assumed",
          "arn:aws:iam::528757785295:role/cloud-custodian-role-assumed",
          "arn:aws:iam::054037137415:role/cloud-custodian-role-assumed",
          "arn:aws:iam::202533508444:role/cloud-custodian-role-assumed",
          "arn:aws:iam::816069130447:role/cloud-custodian-role-assumed",
          "arn:aws:iam::548813917035:role/cloud-custodian-role-assumed",
          "arn:aws:iam::445567083790:role/cloud-custodian-role-assumed",
          "arn:aws:iam::104299473261:role/cloud-custodian-role-assumed",
          "arn:aws:iam::980921753767:role/cloud-custodian-role-assumed",
          "arn:aws:iam::897722679597:role/cloud-custodian-role-assumed",
          "arn:aws:iam::195665324256:role/cloud-custodian-role-assumed"
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