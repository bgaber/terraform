resource "aws_ssm_document" "linux_falcon_sensor" {
  name       = "Install-CrowdStrike-Falcon-Sensor-Linux"
  document_type = "Command"

  permissions = {
    type        = "Share"
    account_ids = join(",", var.ssm_shared_account_ids)
  }

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
        precondition = {
          StringEquals = ["platformType", "Linux"]
        },
        inputs = {
          runCommand = [
            "set -e",
            "INSTALL_SCRIPT_URL='https://raw.githubusercontent.com/crowdstrike/falcon-scripts/v1.8.0/bash/install/falcon-linux-install.sh'",
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

  permissions = {
    type        = "Share"
    account_ids = join(",", var.ssm_shared_account_ids)
  }

  content = jsonencode({
    "schemaVersion": "2.2",
    "description": "Install CrowdStrike Falcon Sensor on Windows",
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
            "precondition": {
                "StringEquals": ["platformType", "Windows"]
            },
            "inputs": {
                "timeoutSeconds": 3600,
                "runCommand": [
                    "$ErrorActionPreference = 'Stop'",
                    "$ProgressPreference = 'SilentlyContinue'",
                    "",
                    "# 1. Download installer script",
                    "$installScriptPath = Join-Path $env:TEMP 'falcon_windows_install.ps1'",
                    "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/crowdstrike/falcon-scripts/v1.8.0/powershell/install/falcon_windows_install.ps1' -OutFile $installScriptPath -UseBasicParsing",
                    "",
                    "# 2. Install sensor directly with credentials",
                    "& $installScriptPath -FalconCloud us-gov-1 -FalconClientId '{{ falconClientId }}' -FalconClientSecret '{{ falconClientSecret }}' -ErrorAction Stop",
                    "",
                    "# 3. Verify installation and service status",
                    "$service = Get-Service -Name CSAgent -ErrorAction SilentlyContinue",
                    "if (-not $service -or $service.Status -ne 'Running') {",
                    "    Write-Error 'CSAgent service not found or not running'",
                    "    exit 1",
                    "}"
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