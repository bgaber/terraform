resource "aws_ssm_parameter" "penultimate_accounts" {
  name  = "/automated_agent_installation/penultimate_accounts"
  type  = "StringList"
  value = join(",", var.penultimate_accounts)
}

resource "aws_ssm_parameter" "latest_accounts" {
  name  = "/automated_agent_installation/latest_accounts"
  type  = "StringList"
  value = join(",", var.latest_accounts)
}

resource "aws_ssm_document" "linux_datadog_agent" {
  name          = "Install-Datadog-Agent-Linux"
  document_type = "Command"
  permissions = {
    type        = "Share"
    account_ids = join(",", var.ssm_shared_account_ids)
  }

  content = jsonencode({
    "schemaVersion": "2.2",
    "description": "Update the Datadog agent only if it already installed.",
    "parameters": {
      "action": {
        "type": "String",
        "description": "(Required) Install or Upgrade",
        "default": "Upgrade",
        "allowedValues": [
          "Install",
          "Upgrade"
        ]
      },
      "apikey": {
        "type": "String",
        "description": "(Required) Datadog API KEY"
      },
      "site": {
        "type": "String",
        "description": "(Optional) Specify the datadog site to use",
        "default": ""
      },
      "tags": {
        "type": "String",
        "description": "(Optional) Specify a list of comma-separated tags",
        "default": ""
      },
      "agentmajorversion": {
        "type": "String",
        "description": "(Optional) Specify the major version of the Datadog Agent",
        "default": "7"
      },
      "agentminorversion": {
        "type": "String",
        "description": "(Optional) Specify the minor version of the Datadog Agent",
        "default": ""
      }
    },
    "mainSteps": [
      {
        "action": "aws:runShellScript",
        "name": "DatadogAgentUpgrade",
        "precondition": {
          "StringEquals": ["platformType", "Linux"]
        },
        "name": "AgentUpgrade",
        "inputs": {
          "runCommand": [
            "set -e",
            "if [ \"{{ action }}\" = \"Upgrade\" ]; then",
            "  # Check if datadog-agent is installed",
            "  if systemctl status datadog-agent >/dev/null 2>&1; then",
            "    echo 'Datadog agent is installed. Proceeding with upgrade ...'",
            "    hn=$(hostname)",
            "    INSTALL_SCRIPT_URL=https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh",
            "    DD_API_KEY=\"{{ apikey }}\" DD_SITE=\"{{ site }}\" DD_HOST_TAGS=\"{{ tags }}\" DD_HOSTNAME=\"$hn\" DD_AGENT_MAJOR_VERSION=\"{{ agentmajorversion }}\" DD_AGENT_MINOR_VERSION=\"{{ agentminorversion }}\" bash -c \"$(curl -L \"$${INSTALL_SCRIPT_URL}\" | sed -e \"s|tool: install_script|tool: aws_run_command|g\" -e \"s|variant=install_script_agent7|variant=aws_run_command-6.0|g\")\"",
            "  else",
            "    echo 'Datadog agent not found. Skipping upgrade.'",
            "  fi",
            "fi",
            "set +e"
          ]
        }
      },
      {
        "action": "aws:runShellScript",
        "name": "DatadogAgentInstallation",
        "precondition": {
          "StringEquals": ["platformType", "Linux"]
        },
        "name": "AgentInstall",
        "inputs": {
          "runCommand": [
            "set -e",
            "if [ \"{{ action }}\" = \"Install\" ]; then",
            "  echo 'Proceeding with installation of Datadog Agent ...'",
            "  hn=$(hostname)",
            "  INSTALL_SCRIPT_URL=https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh",
            "  DD_API_KEY=\"{{ apikey }}\" DD_SITE=\"{{ site }}\" DD_HOST_TAGS=\"{{ tags }}\" DD_HOSTNAME=\"$hn\" DD_AGENT_MAJOR_VERSION=\"{{ agentmajorversion }}\" DD_AGENT_MINOR_VERSION=\"{{ agentminorversion }}\" bash -c \"$(curl -L \"$${INSTALL_SCRIPT_URL}\" | sed -e \"s|tool: install_script|tool: aws_run_command|g\" -e \"s|variant=install_script_agent7|variant=aws_run_command-6.0|g\")\"",
            "fi",
            "set +e"
          ]
        }
      }
    ]
  })
}

resource "aws_ssm_document" "windows_datadog_agent" {
  name            = "Install-Datadog-Agent-Windows"
  document_format = "YAML"
  document_type   = "Command"
  permissions = {
    type        = "Share"
    account_ids = join(",", var.ssm_shared_account_ids)
  }

  content = <<DOC
    schemaVersion: "2.2"
    description: "Install Datadog Agent on Windows"
    parameters:
      action:
        type: String
        description: "(Required) Install or Upgrade"
        default: "Upgrade"
        allowedValues:
          - "Install"
          - "Upgrade"
      apikey:
        description: "Adds the Datadog API KEY to the configuration file."
        type: String
        allowedPattern: "([a-zA-Z0-9]+)?"
        default: ""
      site:
        type: String
        description: "(Optional) Specify the datadog site to use"
        default: ""
      tags:
        type: String
        description: "(Optional) Specify a list of comma-separated tags"
        default: ""
      agentmajorversion:
        type: String
        description: "(Optional) Specify the major version of the Datadog Agent"
        default: "7"
      agentminorversion:
        type: String
        description: "(Optional) Specify the minor version of the Datadog Agent"
        default: ""
    mainSteps:
    - action: aws:runPowerShellScript
      name: DatadogAgentInstallation
      precondition:
        StringEquals:
          - platformType
          - Windows
      inputs:
        runCommand:
          - |
            if (!"{{ apikey }}") {
              Write-Host "apikey parameter is missing"
              Exit 1
            }
            $ErrorActionPreference = "Stop"

            $ServiceName = "datadogagent"
            $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

            if ("{{ action }}" -eq "Install") {
              if ($Service) {
                Write-Host "Datadog agent is already installed. Skipping install."
                Exit 0
              }
              Write-Host "Proceeding with Datadog agent installation."
              # Installation logic here (same as your current script)
            }
            elseif ("{{ action }}" -eq "Upgrade") {
              if (-not $Service) {
                Write-Host "Datadog agent is not installed. Skipping upgrade."
                Exit 0
              }
              if ($Service.Status -ne "Running") {
                Write-Host "Datadog agent service is not running. Skipping upgrade."
                Exit 0
              }
              Write-Host "Proceeding with Datadog agent upgrade."
              # Upgrade logic here (same as your current script)
            }
            else {
              Write-Host "Unknown action specified: {{ action }}"
              Exit 1
            }

            # Shared install/upgrade logic (download MSI, run installer, etc.)
            # Don't put a slash at the end there
            $installerSource = "https://ddagent-windows-stable.s3.amazonaws.com"
            $version = "{{ agentmajorversion }}.{{ agentminorversion }}"
            Write-Host "Version: $version"

            if ($version -eq "latest") {
                # By default, install latest Agent 7
                $installerName = "datadog-agent-7-latest.amd64.msi"
            } else {
                $installerName = "ddagent-cli-$version.msi"
            }
            Write-Host "Installer: $installerName"
            
            # Bump up the TLS profile to the max value supported by the system
            [System.Enum]::GetValues('Net.SecurityProtocolType') |
                    Where-Object { $_ -gt [System.Math]::Max( [Net.ServicePointManager]::SecurityProtocol.value__, [Net.SecurityProtocolType]::Tls.value__ ) } |
                    ForEach-Object {
                        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor $_
                    }
            (New-Object System.Net.WebClient).DownloadFile("$installerSource/$installerName", $installerName)
            
            $timeStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
            $logFileName = "{0}_datadog_install.log" -f $timeStamp
            $logDir = "C:\AwsSSM\DatadogWindowsAgent"
            New-Item -ItemType Directory -Force -Path $logDir
            $logPath = "$logDir\$logFileName"
            $hn = $env:COMPUTERNAME
            $msiArgs = "/log $logPath OVERRIDE_INSTALLATION_METHOD=`"aws_run_command`" APIKEY=`"{{ apikey }}`" SITE=`"{{ site }}`" HOSTNAME=`"$hn`" "
            if ("{{ tags }}") {
              $msiArgs += "TAGS=`"{{ tags }}`" "
            }
            Start-Process "msiexec" -ArgumentList "/qn /i $installerName $msiArgs" -NoNewWindow -Wait -Passthru
            Get-Service -Name "datadogagent"
DOC
}

output "ssm_parameter_penultimate_accounts_arn" {
  value = aws_ssm_parameter.penultimate_accounts.arn
}

output "ssm_parameter_latest_accounts_arn" {
  value = aws_ssm_parameter.latest_accounts.arn
}

output "linux_ssm_document_arn" {
  value = aws_ssm_document.linux_datadog_agent.arn
}

output "linux_ssm_document_id" {
  value = aws_ssm_document.linux_datadog_agent.id
}

output "linux_ssm_document_owner" {
  value = aws_ssm_document.linux_datadog_agent.owner
}

output "linux_ssm_document_schema_version" {
  value = aws_ssm_document.linux_datadog_agent.schema_version
}

output "windows_ssm_document_arn" {
  value = aws_ssm_document.windows_datadog_agent.arn
}

output "windows_ssm_document_id" {
  value = aws_ssm_document.windows_datadog_agent.id
}

output "windows_ssm_document_owner" {
  value = aws_ssm_document.windows_datadog_agent.owner
}

output "windows_ssm_document_schema_version" {
  value = aws_ssm_document.windows_datadog_agent.schema_version
}