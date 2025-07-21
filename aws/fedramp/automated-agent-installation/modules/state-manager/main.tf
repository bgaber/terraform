data "aws_ssm_parameter" "datadog_api_key" {
  name = "DATADOG_API_KEY"
}

resource "aws_ssm_association" "linux_datadog_agent" {
  name = var.linux_ssm_document_name
  association_name    = "linux-datadog-agent-install"
  compliance_severity = "HIGH"
  document_version    = "$DEFAULT"

  schedule_expression = "cron(0 3 * * ? *)" # Run at 3:00 am (UTC) every day

  targets {
    key    = "tag:datadog"
    values = ["true"]
  }

  parameters = {
    action            = var.action
    apikey            = data.aws_ssm_parameter.datadog_api_key.value
    agentmajorversion = var.agentmajorversion
    agentminorversion = var.agentminorversion
  }

  output_location {
    s3_bucket_name = var.s3_output_location
    s3_key_prefix = "linux"
  }
}

resource "aws_ssm_association" "windows_datadog_agent" {
  name = var.windows_ssm_document_name
  association_name    = "windows-datadog-agent-install"
  compliance_severity = "HIGH"
  document_version    = "$DEFAULT"

  schedule_expression = "cron(0 3 * * ? *)" # Run at 3:00 am (UTC) every day

  targets {
    key    = "tag:datadog"
    values = ["true"]
  }

  parameters = {
    action            = var.action
    apikey            = data.aws_ssm_parameter.datadog_api_key.value
    agentmajorversion = var.agentmajorversion
    agentminorversion = var.agentminorversion
  }

  output_location {
    s3_bucket_name = var.s3_output_location
    s3_key_prefix = "windows"
  }
}

output "linux_ssm_association_arn" {
  value = aws_ssm_association.linux_datadog_agent.arn
}

output "linux_ssm_association_id" {
  value = aws_ssm_association.linux_datadog_agent.association_id
}

output "linux_ssm_association_name" {
  value = aws_ssm_association.linux_datadog_agent.name
}

output "windows_ssm_association_arn" {
  value = aws_ssm_association.windows_datadog_agent.arn
}

output "windows_ssm_association_id" {
  value = aws_ssm_association.windows_datadog_agent.association_id
}

output "windows_ssm_association_name" {
  value = aws_ssm_association.windows_datadog_agent.name
}