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
      },
      falconClientSecret = {
        type        = "String"
        description = "(Required) CrowdStrike Falcon Secret"
      },
      falconCloud = {
        type        = "String"
        default     = "us-gov-1"
        description = "CrowdStrike cloud (default: us-gov-1)"
      },
      proxyHost = {
        type        = "String"
        default     = "proxy.zone-proxy.cloud"
        description = "Proxy host (default: proxy.zone-proxy.cloud)"
      },
      proxyPort = {
        type        = "String"
        default     = "3128"
        description = "Proxy port (default: 3128)"
      }
    },
    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "FalconSensorInstallation"
        precondition = {
          StringEquals = ["platformType", "Linux"]
        },
        inputs = {
          timeoutSeconds = 3600
          runCommand = [
            "set -euo pipefail",
            "INSTALL_SCRIPT_URL='https://raw.githubusercontent.com/crowdstrike/falcon-scripts/v1.8.0/bash/install/falcon-linux-install.sh'",
            "FALCON_CLOUD='{{ falconCloud }}'",
            "FALCON_CLIENT_ID='{{ falconClientId }}'",
            "FALCON_CLIENT_SECRET='{{ falconClientSecret }}'",
            "PROXY_HOST='{{ proxyHost }}'",
            "PROXY_PORT='{{ proxyPort }}'",
            "",
            "# --- Validate prerequisites ---",
            "command -v curl >/dev/null 2>&1 || { echo 'ERROR: curl is required but not found. Aborting (no package installs allowed).' >&2; exit 1; }",
            "[ -n \"$FALCON_CLIENT_ID\" ] || { echo 'ERROR: falconClientId is required' >&2; exit 1; }",
            "[ -n \"$FALCON_CLIENT_SECRET\" ] || { echo 'ERROR: falconClientSecret is required' >&2; exit 1; }",
            "[ -n \"$FALCON_CLOUD\" ] || FALCON_CLOUD='us-gov-1'",
            "",
            "# --- Build proxy URL and FORCE its use ---",
            "PROXY_URI=\"http://$${PROXY_HOST}:$${PROXY_PORT}\"",
            "echo \"Using forced proxy: $${PROXY_URI}\"",
            "",
            "# Export proxy for any internal calls the installer makes",
            "export HTTP_PROXY=\"$PROXY_URI\"",
            "export HTTPS_PROXY=\"$PROXY_URI\"",
            "export NO_PROXY=''",
            "",
            "# CrowdStrike script-specific proxy and auth/cloud vars",
            "export FALCON_APH=\"$PROXY_HOST\"",
            "export FALCON_APP=\"$PROXY_PORT\"",
            "export FALCON_CLOUD",
            "export FALCON_CLIENT_ID",
            "export FALCON_CLIENT_SECRET",
            "",
            "# --- Use /root for the installer script (not /tmp) ---",
            "mkdir -p /root",
            "umask 077",
            "TMP_SCRIPT=\"/root/falcon-linux-install.$(date +%s).sh\"",
            "",
            "# --- Download installer with curl ONLY, using explicit --proxy ---",
            "curl -fsSL --retry 3 --connect-timeout 20 --proxy \"$PROXY_URI\" \"$INSTALL_SCRIPT_URL\" -o \"$TMP_SCRIPT\" || {",
            "  echo 'ERROR: Failed to download falcon-linux-install.sh via forced proxy.' >&2; exit 1;",
            "}",
            "chmod 700 \"$TMP_SCRIPT\"",
            "echo \"Downloaded to $TMP_SCRIPT; executing...\"",
            "",
            "# --- Execute installer ---",
            "bash \"$TMP_SCRIPT\"",
            "",
            "# --- Optional: basic service check (no extra installs) ---",
            "if command -v systemctl >/dev/null 2>&1; then",
            "  systemctl is-active --quiet falcon-sensor || systemctl is-active --quiet falcon-sensor.service || echo 'WARN: falcon-sensor service not active (name may differ). Verify manually.' >&2",
            "fi",
            "",
            "echo 'CrowdStrike Falcon Sensor install step completed.'"
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
      "falconCloud": {
        "type": "String",
        "default": "us-gov-1",
        "description": "CrowdStrike cloud (default: us-gov-1)"
      },
      "proxyHost": {
        "type": "String",
        "default": "proxy.zone-proxy.cloud",
        "description": "Proxy host (default: proxy.zone-proxy.cloud)"
      },
      "proxyPort": {
        "type": "String",
        "default": "3128",
        "description": "Proxy port (default: 3128)"
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
            "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12",
            "",
            "$FalconClientId     = '{{ falconClientId }}'",
            "$FalconClientSecret = '{{ falconClientSecret }}'",
            "$FalconCloud        = '{{ falconCloud }}'",
            "$ProxyHost          = '{{ proxyHost }}'",
            "$ProxyPort          = '{{ proxyPort }}'",
            "if ([string]::IsNullOrWhiteSpace($FalconClientId))    { throw 'FalconClientId is required.' }",
            "if ([string]::IsNullOrWhiteSpace($FalconClientSecret)) { throw 'FalconClientSecret is required.' }",
            "if ([string]::IsNullOrWhiteSpace($FalconCloud))        { $FalconCloud = 'us-gov-1' }",
            "",
            "# Build canonical proxy parts",
            "$ProxyUri     = 'http://' + $ProxyHost + ':' + $ProxyPort",
            "$ProxyWinHttp = ('{0}:{1}' -f $ProxyHost, $ProxyPort)  # >>> avoids \"$ProxyHost:$ProxyPort\" parsing issue",
            "Write-Host ('Forcing proxy for all network operations: ' + $ProxyUri)",
            "",
            "# Capture current WinHTTP proxy to restore later",
            "function Get-WinHttpProxy {",
            "  try { (netsh winhttp show proxy) -join [Environment]::NewLine } catch { '' }",
            "}",
            "$OldWinHttp = Get-WinHttpProxy",
            "",
            "# Force WinHTTP to our proxy (helps BITS/system).",
            "try {",
            "  Start-Process -FilePath 'netsh' -ArgumentList @('winhttp','set','proxy', $ProxyWinHttp) -NoNewWindow -Wait   # >>> pass pre-built string",
            "} catch { Write-Warning ('Failed to set WinHTTP proxy: ' + $_.Exception.Message) }",
            "",
            "# Make .NET use our proxy explicitly",
            "$explicitProxy = New-Object System.Net.WebProxy($ProxyUri, $true)",
            "$explicitProxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials",
            "[System.Net.WebRequest]::DefaultWebProxy = $explicitProxy",
            "",
            "function Download-FileForcedProxy {",
            "  param([string]$Url,[string]$OutFile,[string]$Proxy)",
            "  try {",
            "    $iwrParams = @{ Uri=$Url; OutFile=$OutFile; UseBasicParsing=$true; MaximumRedirection=5; TimeoutSec=180; Proxy=$Proxy; ProxyUseDefaultCredentials=$true }",
            "    Invoke-WebRequest @iwrParams",
            "    return $true",
            "  } catch { Write-Warning ('Invoke-WebRequest via proxy failed: ' + $_.Exception.Message) }",
            "  try {",
            "    Start-BitsTransfer -Source $Url -Destination $OutFile -ProxyUsage Override -ProxyList $Proxy -ErrorAction Stop",
            "    return $true",
            "  } catch { Write-Warning ('BITS via proxy failed: ' + $_.Exception.Message) }",
            "  try {",
            "    $curl = (Get-Command curl.exe -ErrorAction SilentlyContinue).Source",
            "    if ($curl) {",
            "      $args = @('-L', $Url, '--proxy', $Proxy, '-o', $OutFile, '--max-time', '180')",
            "      $p = Start-Process -FilePath $curl -ArgumentList $args -NoNewWindow -PassThru -Wait",
            "      if ($p.ExitCode -eq 0) { return $true }",
            "      else { Write-Warning ('curl exit code: ' + $p.ExitCode) }",
            "    } else { Write-Warning 'curl.exe not found' }",
            "  } catch { Write-Warning ('curl via proxy failed: ' + $_.Exception.Message) }",
            "  return $false",
            "}",
            "",
            "$Uri  = 'https://raw.githubusercontent.com/crowdstrike/falcon-scripts/v1.8.0/powershell/install/falcon_windows_install.ps1'",
            "$Dest = Join-Path $env:TEMP 'falcon_windows_install.ps1'",
            "",
            "try {",
            "  if (-not (Download-FileForcedProxy -Url $Uri -OutFile $Dest -Proxy $ProxyUri)) {",
            "    throw 'Failed to download falcon_windows_install.ps1 using explicit proxy. If GitHub is blocked, mirror the file to an allowed endpoint and update $Uri.'",
            "  }",
            "",
            "  Write-Host ('Resolved Falcon cloud: ' + $FalconCloud)",
            "",
            "  $params = @{",
            "    'FalconCloud'        = $FalconCloud",
            "    'FalconClientId'     = $FalconClientId",
            "    'FalconClientSecret' = $FalconClientSecret",
            "    'ProxyHost'          = $ProxyHost",
            "    'ProxyPort'          = [int]$ProxyPort",
            "  }",
            "",
            "  & $Dest @params -ErrorAction Stop",
            "",
            "  $svc = Get-Service -Name 'CSAgent' -ErrorAction SilentlyContinue",
            "  if (-not $svc -or $svc.Status -ne 'Running') { throw 'CSAgent service not running after install.' }",
            "  Write-Host 'CrowdStrike Falcon Sensor installed and running.'",
            "} finally {",
            "  # Restore original WinHTTP proxy safely",
            "  try {",
            "    if ($OldWinHttp -match 'Direct access \\(no proxy server\\)') {",
            "      Start-Process -FilePath 'netsh' -ArgumentList @('winhttp','reset','proxy') -NoNewWindow -Wait",
            "    } else {",
            "      $m = [regex]::Match($OldWinHttp,'Proxy Server\\s*:\\s*(.+)')   # >>> use explicit regex match object",
            "      if ($m.Success) {",
            "        $prev = $m.Groups[1].Value.Trim()",
            "        Start-Process -FilePath 'netsh' -ArgumentList @('winhttp','set','proxy', $prev) -NoNewWindow -Wait",
            "      } else {",
            "        Start-Process -FilePath 'netsh' -ArgumentList @('winhttp','reset','proxy') -NoNewWindow -Wait",
            "      }",
            "    }",
            "  } catch { Write-Warning ('Failed to restore WinHTTP proxy: ' + $_.Exception.Message) }",
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