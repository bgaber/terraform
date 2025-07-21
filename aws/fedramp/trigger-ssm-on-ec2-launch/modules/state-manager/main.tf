data "aws_ssm_parameter" "falcon_client_id" {
  name = "/CrowdStrike/Falcon/ClientId"
}

data "aws_ssm_parameter" "falcon_client_secret" {
  name = "/CrowdStrike/Falcon/ClientSecret"
}

resource "aws_ssm_association" "linux_falcon_sensor" {
  name = var.linux_ssm_document_name
  association_name    = "linux-falcon-sensor-install"
  compliance_severity = "HIGH"
  document_version    = "$DEFAULT"

  targets {
    key    = "InstanceIds"
    values = ["*"]
  }

  parameters = {
    falconClientId     = data.aws_ssm_parameter.falcon_client_id.value
    falconClientSecret = data.aws_ssm_parameter.falcon_client_secret.value
  }

  output_location {
    s3_bucket_name = var.s3_output_location
    s3_key_prefix = "linux"
  }
}

resource "aws_ssm_association" "windows_falcon_sensor" {
  name = var.windows_ssm_document_name
  association_name    = "windows-falcon-sensor-install"
  compliance_severity = "HIGH"
  document_version    = "$DEFAULT"

  targets {
    key    = "InstanceIds"
    values = ["*"]
  }

  parameters = {
    falconClientId     = data.aws_ssm_parameter.falcon_client_id.value
    falconClientSecret = data.aws_ssm_parameter.falcon_client_secret.value
  }

  output_location {
    s3_bucket_name = var.s3_output_location
    s3_key_prefix = "windows"
  }
}

output "linux_ssm_association_arn" {
  value = aws_ssm_association.linux_falcon_sensor.arn
}

output "linux_ssm_association_id" {
  value = aws_ssm_association.linux_falcon_sensor.association_id
}

output "linux_ssm_association_name" {
  value = aws_ssm_association.linux_falcon_sensor.name
}

output "windows_ssm_association_arn" {
  value = aws_ssm_association.windows_falcon_sensor.arn
}

output "windows_ssm_association_id" {
  value = aws_ssm_association.windows_falcon_sensor.association_id
}

output "windows_ssm_association_name" {
  value = aws_ssm_association.windows_falcon_sensor.name
}