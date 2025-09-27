resource "aws_ssm_document" "falcon_sensor" {
  name       = "Install-CrowdStrike-Falcon-Sensor"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Install CrowdStrike Falcon Sensor on Linux."
    parameters    = {
      falconClientId = {
        type        = "String"
        description = "(Required) CrowdStrike Falcon Client Id"
      }
      falconClientSecret = {
        type        = "String"
        description = "(Required) CrowdStrike Falcon Secret"
      }
    }
    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "FalconSensorInstallation"
        inputs = {
          runCommand = [
            "set -e",
            "INSTALL_SCRIPT_URL='https://raw.githubusercontent.com/crowdstrike/falcon-scripts/v1.7.3/bash/install/falcon-linux-install.sh'",
            "export FALCON_CLOUD=us-gov-1",
            "export FALCON_CLIENT_ID='{{ falconClientId }}'",
            "export FALCON_CLIENT_SECRET='{{ falconClientSecret }}'",
            "curl -L \"$INSTALL_SCRIPT_URL\" | bash",
            "set +e"
          ]
        }
      }
    ]
  })
}

output "aws_ssm_document_arn" {
  value = aws_ssm_document.falcon_sensor.arn
}

output "aws_ssm_document_id" {
  value = aws_ssm_document.falcon_sensor.id
}

output "aws_ssm_document_owner" {
  value = aws_ssm_document.falcon_sensor.owner
}

output "aws_ssm_document_schema_version" {
  value = aws_ssm_document.falcon_sensor.schema_version
}