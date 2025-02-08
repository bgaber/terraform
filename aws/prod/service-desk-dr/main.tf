# The purpose of this Terraform code is to provision an Amazon Connect instance in the ca-central-1 region of the Prod account for the Service Desk DR project

data "aws_caller_identity" "canada" {}

locals {
    account_id = data.aws_caller_identity.canada.account_id
}

resource "aws_connect_instance" "prod" {
  contact_flow_logs_enabled      = true
  identity_management_type       = "CONNECT_MANAGED"
  inbound_calls_enabled          = true
  instance_alias                 = var.instance_alias_name
  outbound_calls_enabled         = true
  multi_party_conference_enabled = true
}

# ConnectKVS2Audio Lambda function
# resource "aws_connect_lambda_function_association" "prod" {
#   function_arn = aws_lambda_function.prod.arn
#   instance_id  = aws_connect_instance.prod.id
# }

# Data Storage - Chat transcripts
resource "aws_connect_instance_storage_config" "prod_chat" {
  instance_id   = aws_connect_instance.prod.id
  resource_type = "CHAT_TRANSCRIPTS"

  storage_config {
    s3_config {
      bucket_name   = var.s3_bucket_name
      bucket_prefix = join("/", ["connect", var.instance_alias_name, "ChatTranscripts"])

    #   encryption_config {
    #     encryption_type = "KMS"
    #     key_id          = aws_kms_key.example.arn
    #   }
    }
    storage_type = "S3"
  }
}

# Data Storage - Call recordings
resource "aws_connect_instance_storage_config" "prod_calls" {
  instance_id   = aws_connect_instance.prod.id
  resource_type = "CALL_RECORDINGS"

  storage_config {
    s3_config {
      bucket_name   = var.s3_bucket_name
      bucket_prefix = join("/", ["connect", var.instance_alias_name, "CallRecordings"])

    #   encryption_config {
    #     encryption_type = "KMS"
    #     key_id          = aws_kms_key.example.arn
    #   }
    }
    storage_type = "S3"
  }
}

# Data Storage - Live media streaming
# resource "aws_connect_instance_storage_config" "prod_video" {
#   instance_id   = aws_connect_instance.prod.id
#   resource_type = "MEDIA_STREAMS"

#   storage_config {
#     kinesis_video_stream_config {
#       prefix                 = "ivr-recording"
#       retention_period_hours = 48

#       encryption_config {
#         encryption_type = "KMS"
#         key_id          = aws_kms_key.example.arn
#       }
#     }
#     storage_type = "KINESIS_VIDEO_STREAM"
#   }
# }

# Data Storage - Exported reports
resource "aws_connect_instance_storage_config" "prod_report" {
  instance_id   = aws_connect_instance.prod.id
  resource_type = "SCHEDULED_REPORTS"

  storage_config {
    s3_config {
      bucket_name   = var.s3_bucket_name
      bucket_prefix = join("/", ["connect", var.instance_alias_name, "Reports"])

    #   encryption_config {
    #     encryption_type = "KMS"
    #     key_id          = aws_kms_key.example.arn
    #   }
    }
    storage_type = "S3"
  }
}

# Amazon Connect Customer Profiles not supported in Terraform, but are supported in CloudFormation (AWS::CustomerProfiles::Domain)
# NOT SUPPORTED IN TERRAFORM - Approved origins (domains)
# NOT SUPPORTED IN TERRAFORM - Customer Profiles domain

output "aws_connect_instance_id" {
  value = aws_connect_instance.prod.id
}

output "aws_connect_instance_arn" {
  value = aws_connect_instance.prod.arn
}

output "aws_connect_instance_service_role" {
  value = aws_connect_instance.prod.service_role
}