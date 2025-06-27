resource "aws_ssm_document" "linux_falcon_sensor" {
  name       = "Install-CrowdStrike-Falcon-Sensor-Linux"
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

resource "aws_ssm_document" "windows_falcon_sensor" {
  name       = "Install-CrowdStrike-Falcon-Sensor-Windows"
  document_type = "Command"

  content = jsonencode({
    "schemaVersion": "2.2",
    "description": "Install CrowdStrike Falcon Sensor on Windows.",
    "parameters": {
      "falconClientId": {
        "type": "String",
        "description": "(Required) CrowdStrike Falcon Client Id"
      },
      "falconClientSecret": {
        "type": "String",
        "description": "(Required) CrowdStrike Falcon Secret"
      }
    },
    "mainSteps": [
      {
        "action": "aws:runPowerShellScript",
        "name": "FalconSensorInstallation",
        "inputs": {
          "runCommand": [
            "Set-StrictMode -Version Latest",
            "$ErrorActionPreference = 'Stop'",
            "",
            "# Define variables",
            "$INSTALL_SCRIPT_URL = 'https://raw.githubusercontent.com/crowdstrike/falcon-scripts/v1.7.2/powershell/install/falcon_windows_install.ps1'",
            "$INSTALL_SCRIPT_PATH = 'C:\\Users\\Public\\Downloads\\falcon_windows_install.ps1'",
            "",
            "# Download the Falcon install script",
            "Invoke-WebRequest -Uri $INSTALL_SCRIPT_URL -OutFile $INSTALL_SCRIPT_PATH",
            "",
            "# Change to the script directory",
            "Set-Location C:\\Users\\Public\\Downloads",
            "",
            "# Execute the install script to retrieve the provisioning token",
            "$provTokenOutput = & .\\falcon_windows_install.ps1 -FalconCloud us-gov-1 -FalconClientId '{{ falconClientId }}' -FalconClientSecret '{{ falconClientSecret }}' -GetAccessToken",
            "",
            "# Extract the provisioning token from output",
            "$provToken = ($provTokenOutput | ConvertFrom-Json).ProvisioningToken",
            "",
            "# Execute the install script with the provisioning token",
            "& .\\falcon_windows_install.ps1 -FalconCloud us-gov-1 -FalconClientId '{{ falconClientId }}' -FalconClientSecret '{{ falconClientSecret }}' -ProvToken $provToken",
            "",
            "Write-Output 'CrowdStrike Falcon Sensor installation completed successfully.'"
          ]
        }
      }
    ]
  })
}

output "linux_ssm_document_arn" {
  value = aws_ssm_document.linux_falcon_sensor.arn
}

output "linux_ssm_document_id" {
  value = aws_ssm_document.linux_falcon_sensor.id
}

output "linux_ssm_document_owner" {
  value = aws_ssm_document.linux_falcon_sensor.owner
}

output "linux_ssm_document_schema_version" {
  value = aws_ssm_document.linux_falcon_sensor.schema_version
}

output "windows_ssm_document_arn" {
  value = aws_ssm_document.windows_falcon_sensor.arn
}

output "windows_ssm_document_id" {
  value = aws_ssm_document.windows_falcon_sensor.id
}

output "windows_ssm_document_owner" {
  value = aws_ssm_document.windows_falcon_sensor.owner
}

output "windows_ssm_document_schema_version" {
  value = aws_ssm_document.windows_falcon_sensor.schema_version
}