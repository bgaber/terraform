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
      "apikey": {
        "type": "String",
        "description": "(Required) Datadog API KEY"
      },
      "site": {
        "type": "String",
        "description": "(Optional) Specify the datadog site to use",
        "default": ""
      },
      "hostname": {
        "type": "String",
        "description": "(Optional) Specify the hostname",
        "default": ""
      },
      "tags": {
        "type": "String",
        "description": "(Optional) Specify a list of comma-separated tags",
        "default": ""
      },
      "agentmajorversion": {
        "type": "String",
        "description": "(Optional) Specify the major version of the agent",
        "default": "7"
      },
      "agentminorversion": {
        "type": "String",
        "description": "(Optional) Specify the minor version of the agent",
        "default": ""
      }
    },
    "mainSteps": [
      {
        "action": "aws:runShellScript",
        "name": "DatadogAgentInstallation",
          "precondition": {
            "StringEquals": ["platformType", "Linux"]
          },
        "name": "AgentConditionalInstall",
        "inputs": {
          "runCommand": [
            "set -e",
            "# Check if datadog-agent is installed",
            "if systemctl status datadog-agent >/dev/null 2>&1; then",
            "  echo 'Datadog agent is installed. Proceeding with upgrade...'",
            "  INSTALL_SCRIPT_URL=https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh",
            #"  DD_API_KEY=\"{{ apikey }}\" DD_SITE=\"{{ site }}\" DD_HOST_TAGS=\"{{ tags }}\" DD_HOSTNAME=\"{{ hostname }}\" DD_AGENT_MAJOR_VERSION=\"{{ agentmajorversion }}\" DD_AGENT_MINOR_VERSION=\"{{ agentminorversion }}\" bash -c \"$(curl -L \\\"${INSTALL_SCRIPT_URL}\\\" | sed -e \\\"s|tool: install_script|tool: aws_run_command|g\\\" -e \\\"s|variant=install_script_agent7|variant=aws_run_command-6.0|g\\\")\"",
            "  DD_API_KEY=\"{{ apikey }}\" DD_SITE=\"{{ site }}\" DD_HOST_TAGS=\"{{ tags }}\" DD_HOSTNAME=\"{{ hostname }}\" DD_AGENT_MAJOR_VERSION=\"{{ agentmajorversion }}\" DD_AGENT_MINOR_VERSION=\"{{ agentminorversion }}\" bash -c \"$(curl -L \"$${INSTALL_SCRIPT_URL}\" | sed -e \"s|tool: install_script|tool: aws_run_command|g\" -e \"s|variant=install_script_agent7|variant=aws_run_command-6.0|g\")\"",
            "else",
            "  echo 'Datadog agent not found. Skipping installation.'",
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
      apikey:
        description: "Adds the Datadog API KEY to the configuration file."
        type: String
        allowedPattern: "([a-zA-Z0-9]+)?"
        default: ""
      site:
        type: String
        description: "(Optional) Specify the datadog site to use"
        default: ""
      hostname:
        type: String
        description: "(Optional) Specify the hostname"
        default: ""
      tags:
        type: String
        description: "(Optional) Specify a list of comma-separated tags"
        default: ""
      agentmajorversion:
        type: String
        description: "(Optional) Specify the major version of the agent"
        default: "7"
      agentminorversion:
        type: String
        description: "(Optional) Specify the minor version of the agent"
        default: ""
    mainSteps:
    - action: aws:runPowerShellScript
      name: DatadogAgentInstall
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
          $msiArgs = "/log $logPath OVERRIDE_INSTALLATION_METHOD=`"aws_run_command`" APIKEY=`"{{ apikey }}`" SITE=`"{{ site }}`" "
          if ("{{ hostname }}") {
            $msiArgs += "HOSTNAME=`"{{ hostname }}`" "
          }
          if ("{{ tags }}") {
            $msiArgs += "TAGS=`"{{ tags }}`" "
          }
          Start-Process "msiexec" -ArgumentList "/qn /i $installerName $msiArgs" -NoNewWindow -Wait -Passthru
          Get-Service -Name "datadogagent"
DOC
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