# Automated upgrade of Datadog agents on EC2 servers

[![AWS](https://custom-icon-badges.demolab.com/badge/AWS%20IAM-%23FF9900.svg?logo=aws&logoColor=white)](#)
[![AWS](https://custom-icon-badges.demolab.com/badge/AWS%20EventBridge-%23FF9900.svg?logo=aws&logoColor=white)](#)
[![AWS Lambda](https://custom-icon-badges.demolab.com/badge/AWS%20Lambda-%23FF9900.svg?logo=aws-lambda&logoColor=white)](#)
[![AWS](https://custom-icon-badges.demolab.com/badge/AWS%20Athena-%23FF9900.svg?logo=aws&logoColor=white)](#)
[![AWS](https://custom-icon-badges.demolab.com/badge/AWS%20S3-%23FF9900.svg?logo=aws&logoColor=white)](#)
[![AWS](https://custom-icon-badges.demolab.com/badge/AWS%20SSM-%23FF9900.svg?logo=aws&logoColor=white)](#)
[![AWS](https://custom-icon-badges.demolab.com/badge/AWS%20Parameter%20Store-%23FF9900.svg?logo=aws&logoColor=white)](#)
![Datadog](https://img.shields.io/badge/Datadog-632CA6?logo=datadog&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-5C4EE5?logo=terraform&logoColor=white)

# Overview

The purpose of this multi-account solution is to automatically upgrade to the latest version of the Datadog agent on all EC2 instances in a testing account and the penultimate version of the Datadog agent on all EC2 instances in all customer accounts.

# Authentication and Authorization

Every GitLab Pipeline must authenticate before it can provision resources. The type of credentials required depends on the systems being managed:

- **AWS resources with Terraform**: The pipeline requires an **IAM user** (service account) and, in some cases, one or more **IAM roles** that the user or pipeline assumes.  
- **Kubernetes resources with Helm**: The pipeline requires a **Kubernetes Service Account (SA)** with the appropriate RBAC permissions.  

If you were running the code in this repository manually from a Linux CLI, your user identity would need equivalent permissions (for example, an AWS User with IAM policies granting permission to create, update, or destroy infrastructure).  

👉 The key takeaway is that **authentication is always required** for a GitLab Pipeline, and **authorization** determines *what actions that identity can perform* once authenticated.

## How Authentication and Authorization Are Set Up in This Repository

Since this pipeline uses Terraform to provision AWS resources, it requires AWS credentials. These credentials consist of the following:

* AWS Access Key ID
* AWS Secret Access Key
* (Optionally) an IAM Role ARN that can be assumed by the pipeline for temporary, scoped permissions.

These values are manually generated in AWS (or in some cases, provided by your AWS administrator) and then stored as GitLab CI/CD Variables. This allows the pipeline to authenticate securely without hardcoding secrets in the repository.

When the pipeline runs:

1. GitLab injects the stored credentials into the job environment.
2. Terraform uses these credentials to authenticate to AWS.
3. AWS IAM policies and roles determine which resources the pipeline is authorized to provision or manage.

The IAM User and IAM Roles used by this GitLab Pipeline were created and managed by Terraform code in the following repository: https://gitlab.tecsysrd.cloud/briang/terraform/-/tree/main/aws/fedramp/automated-dd-agent-upgrade-iam?ref_type=heads

## Authentication Flow Diagram

```mermaid
graph TD
    A[GitLab Pipeline Job] -->|"Read from CI/CD Variables"| B[AWS Access Key ID]
    A -->|"Read from CI/CD Variables"| C[AWS Secret Access Key]
    A -->|"Optionally assume"| D[IAM Role ARN]
    B --> E[AWS API]
    C --> E
    D --> E
    E -->|"Authorize based on IAM Policies and Roles"| F["AWS Resources (Terraform-managed)"]
```

# Architecture

![Alt text](images/automated-agent-installation-poc.png?raw=true "Automated Datadog Agent Upgrade Architecture Diagram")

As shown in the diagram above, this solution is primarily comprised AWS Services.  The solution components are listed below:

* AWS EventBridge Scheduler
* AWS Lambda Function
* AWS Athena
* AWS Glue
* AWS S3
* AWS Simple Notification Service (SNS)
* AWS Systems Manager (SSM) Documents (Linux and Windows)
* SSM State Manager
* Datadog

## High-level Solution Workflow

```mermaid
graph TD
    A[EventBridge Scheduler] --> B{Lambda function<br>Is latest version approved?}
    B -->|No| C{If not approved for > 30 days}
    C -->|No| D[Abort]
    C -->|Yes| E[SNS send email notification]
    B -->|Yes| F[SSM Run Command]
    B -->|Yes| G[Mute Datadog]
```

1. EventBridge Scheduler is configured to trigger the Lambda function every Saturday at 7 am UTC.

2. Lambda function will perform these tasks:​

    - Execute Athena/Glue SQL query of CSV object (version-approvals.csv) in S3 bucket​

    - If latest version not approved then check age of CSV object (version-approvals.csv) in S3 bucket and if older than 30 days send SNS notification to NOC team​

    - If latest version is approved then mute Datadog and trigger SSM Run Command​

3. SSM Run Command will upgrade to the penultimate version of agent on customer EC2 instances and latest version of agent on Staging Patch EC2 instances.​

4. SSM State Manager will install the penultimate version of the agent on non-K8s worker node EC2 instances.

## Importance of the version-approvals.csv file

The NOC team has complete control of when agent upgrades occur via the version-approvals.csv file.  If the CSV file looks something like this:

```
Version,Approved
7.68.0,No
7.67.1,Yes
7.67.0,Yes
7.66.1,Yes
7.66.0,Yes
7.65.2,Yes
7.65.1,Yes
7.65.0,Yes
7.64.3,Yes
7.64.2,Yes
7.64.1,Yes
7.64.0,Yes
7.63.3,Yes
7.63.2,Yes
7.63.1,Yes
7.63.0,Yes
```

then nothing will happen because the latest version is not approved.  However, if the CSV file looks something like this:

```
Version,Approved
7.68.0,Yes
7.67.1,Yes
7.67.0,Yes
7.66.1,Yes
7.66.0,Yes
7.65.2,Yes
7.65.1,Yes
7.65.0,Yes
7.64.3,Yes
7.64.2,Yes
7.64.1,Yes
7.64.0,Yes
7.63.3,Yes
7.63.2,Yes
7.63.1,Yes
7.63.0,Yes
```

then the agent upgrade will occur because the latest version is approved.

Therefore, whenever the NOC team wants an automated upgrade to occur they should upload a new, properly formated, `version-approvals.csv` to the `noc-athena-bucket` and then the next time EventBridge
triggers the Lambda function the Datadog agents will be upgraded.

# Setup

This section explains any components that require a substantial setup before the solution can execute successfully.

To understand this setup it is necessary to understand how the Lambda function works with the SSM Documents (Linux and Windows).  The Lambda function only exists on one account, the parent account.  This parent account is also the owner of the two SSM Documents.  The SSM Document is shared by this Parent account to all target accounts.  Also, one account must be desginated as the account where the latest version of the agent is installed for testing and verification.  With this understanding lets understand some of the Terraform files.

## Terraform module root main.tf file setup

At the time this document was written the Security account was selected as the Parent account.  Thus, the top of the root `main.tf` file looks like this:

```
module "fedramp_security_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_security
  }
}

module "fedramp_security_state_manager" {
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_id
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_security
  }
}

module "fedramp_security_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_security
  }
}

module "fedramp_security_eb_lambda" {
  linux_ssm_document_name     = module.fedramp_security_ssm.linux_ssm_document_id
  linux_ssm_document_arn      = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name   = module.fedramp_security_ssm.windows_ssm_document_id
  windows_ssm_document_arn    = module.fedramp_security_ssm.windows_ssm_document_arn
  sns_topic_arn               = module.fedramp_security_sns.sns_topic_arn
  lambda_role_name            = var.lambda_role_name
  lambda_policy_name          = var.lambda_policy_name
  lambda_iam_assume_role_name = var.lambda_iam_assume_role_name
  source = "./modules/eb-lambda"
  providers = {
    aws = aws.fedramp_security
  }
}
...
...
```

This is the only account that uses the ssm, sns and eb-lambda modules because the SSM Documents, SNS Topic, Event Bridge rule and Lambda function only exist in the Security account.  All other accounts call two modules in the root `main.tf` file as shown below:

```
module "fedramp_agencysim_npri_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = module.fedramp_security_eb_lambda.lambda_role_arn ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
}

module "fedramp_agencysim_npri_state_manager" {
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
}
...
...
```

These two modules create the necessary IAM Role that will be assumed by the Lambda function and creates the SSM State Manager association with the shared SSM Documents.  Notice that the three Kubernetes accounts (fedramp_k8s_npr,fedramp_k8s_npri and fedramp_k8s_prd) do not call the State Manager module because we do not want the Datadog agent installed on K8s worker nodes.

## Terraform eb-lambda module main.tf file setup

In the Lambda function's IAM Policy each target account IAM role must be specified as assumable so that it can be assumed by the Lambda function running in the parent account.  This IAM Policy is defined in the eb-lambda module's `main.tf` file and currently looks like this:

```
resource "aws_iam_policy" "lambda_policy" {
  name        = var.lambda_policy_name
  description = "Grants Lambda access to Athena and S3 query results"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["sts:AssumeRole"],
        Resource = [
          "arn:aws:iam::438979369891:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::686255941416:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::311141548321:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::528757785295:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::054037137415:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::202533508444:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::816069130447:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::104299473261:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::445567083790:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::548813917035:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::897722679597:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::195665324256:role/${var.lambda_iam_assume_role_name}"
        ]
      },
...
...
```

It is important to notice that the parent account (Security) is not in this IAM Policy.  In the future if accounts are added or removed this IAM Policy will have to be modified.

## Terraform ssm module variables.tf file setup

The two SSM Documents (Linux and Windows) are created in and owned by the Parent (Security) account.  Therefore, they must be shared with all target accounts.  This is done in the ssm module's `variables.tf` file shown below:

```
variable "ssm_shared_account_ids" {
  description = "List of AWS account IDs to share the SSM document with"
  type        = list(string)
  default     = [
    "438979369891",
    "686255941416",
    "311141548321",
    "528757785295",
    "054037137415",
    "202533508444",
    "816069130447",
    "104299473261",
    "445567083790",
    "548813917035",
    "897722679597",
    "195665324256"
  ]
}

variable "penultimate_accounts" {
  description = "List of AWS account IDs that will have the penultimate agent version installed"
  type        = list(string)
  default     = [
    "438979369891",
    "686255941416",
    "311141548321",
    "528757785295",
    "054037137415",
    "202533508444",
    "816069130447",
    "104299473261",
    "445567083790",
    "548813917035",
    "980921753767",
    "195665324256"
  ]
}

variable "latest_accounts" {
  description = "List of AWS account IDs that will have the latest agent version installed"
  type        = list(string)
  default     = [
    "897722679597"
  ]
}
```

The `ssm_shared_account_ids` variable specifies the target accounts with which to share the SSM Documents.

The `penultimate_accounts` variable specifies which accounts will get the penultimate version of the Datadog agent.

The `latest_accounts` variable specifies which account will get the latest version of the Datadog agent.

## AWS SSO Config Profiles Setup required by Terraform for multi-account installation of SSM Document

In order for this Terraform module to provision the AWS resources in every FedRAMP AWS account an AWS config file needs to be created that has a profile for each AWS account that will work with AWS Identity Center.
At the time this document was written there were 13 FedRAMP AWS accounts and the following is the `~/.aws/config` required for these accounts:

```
[default]
sso_session = fedramp-session
region = us-east-1
output = json

[sso-session fedramp-session]
sso_region = us-east-1
sso_start_url = https://d-9067d80a1d.awsapps.com/start
sso_registration_scopes = sso:account:access

[profile fedramp-agencysim-npri]
sso_session = fedramp-session
sso_account_id = 438979369891
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-integration-npr]
sso_session = fedramp-session
sso_account_id = 686255941416
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-integration-npri]
sso_session = fedramp-session
sso_account_id = 311141548321
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-integration-prd]
sso_session = fedramp-session
sso_account_id = 528757785295
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-k8s-npr]
sso_session = fedramp-session
sso_account_id = 054037137415
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-k8s-npri]
sso_session = fedramp-session
sso_account_id = 202533508444
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-k8s-prd]
sso_session = fedramp-session
sso_account_id = 816069130447
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-network-npr]
sso_session = fedramp-session
sso_account_id = 104299473261
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-network-npri]
sso_session = fedramp-session
sso_account_id = 445567083790
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-network-prd]
sso_session = fedramp-session
sso_account_id = 548813917035
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-security]
sso_session = fedramp-session
sso_account_id = 980921753767
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-tools-npri]
sso_session = fedramp-session
sso_account_id = 897722679597
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-tools-prd]
sso_session = fedramp-session
sso_account_id = 195665324256
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-main]
sso_session = fedramp-session
sso_account_id = 418295679780
sso_role_name = SecurityAudit
region = us-east-1
output = json
```

## Steps to authenticate to AWS Identity Center

1.  Run this command from Linux CLI

```
aws sso login --sso-session fedramp-session --use-device-code
```

2. It will output a URL that you need to put into you browser.  Something like:

```
https://d-90677c141c.awsapps.com/start/#/device?user_code=ZWSV-FKLQ
```

3.  Your browser should output something like this:

![Alt text](images/aws-sso-login-1.png?raw=true "First browser response")
![Alt text](images/aws-sso-login-2.png?raw=true "Second browser response")
![Alt text](images/aws-sso-login-3.png?raw=true "Third browser response")

At this point you should be able to run an AWS CLI command on any of the FedRAMP AWS accounts.  For example:

```
aws s3 ls --profile fedramp-security
```

The profile must match one of the the profile values in the AWS config file above.

## Lambda Function Prerequisites

Each AWS account that you want to have Datadog agents upgraded by this process needs to have these three Parameter Store variables setup before running the Lambda function:

* DATADOG_SITE (value will be `datadoghq.com` for NPRI or `ddog-gov.com` for NPR and PRD)
* DATADOG_API_KEY
* DATADOG_APP_KEY

## Lambda Function

The Lambda function is built from Python code that requires the Datadog requests package to make Datadog API calls to mute Datadog.  This Datadog requests package is put into a Lambda layer that is used by the Lambda function.

### How does the Lambda Function tell SSM on which EC2 Instances to install which Agent version

There a various ways to select which EC2 instances will have the Datadog Agent installed.  In this PoC I have used EC2 tags.  If an EC2 has the `dd_agent` tag with value of `latest` then the latest version found in the `version-approvals.csv` is installed
on that EC2.  However, if an EC2 has the `dd_agent` tag with value of `penultimate` then the penultimate version found in the `version-approvals.csv` is installed on that EC2.  In a production implementation we may want to change that to select based on the
AWS account number.

![Alt text](images/select-ec2-with-tag.png?raw=true "Python code that selects EC2 instances by tag in SSM call")

## Athena/Glue

Athena is used to make SQL calls of the version-approvals.csv file which is located in a S3 bucket.  In order for Athena to make SQL queries it requires a Glue Database and Table.  The Glue Table contains the schema of the version-approvals.csv file and this schema is used by Athena.

## Systems Managager (SSM)

A SSM Document is required that contains the logic to install or upgrade the Datadog agent on a EC2 instances.  AWS already provides a Datadog SSM Document to install the latest version of the Datadog agent on the EC2 instances.  I modelled my SSM Document on the AWS provided document and modified it to accept the passing of `agentmajorversion` and `agentminorversion` parameters and use the OS value for hostname.  The code snippet below shows the modifications I made to my custom Datadog SSM Document called **Install-Datadog-Agent-Linux**

```json
{
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
```

The SSM Run Command uses this SSM Document to upgrade the Datadog agents and record what it has done in the Run Command history.

# Infrastructure as Code (IaC) Deployment

This entire solution, including the GitLab project and pipeline, was deployed using Terraform.  One Terraform project ([GitLab Project IaC](https://gitlab.tecsysrd.cloud/briang/terraform/-/tree/main/gitlab/automated-agent-installation-repo?ref_type=heads)) was used to provision the GitLab project and pipeline and this, second Terraform project, was used to provision all the AWS Services.

The advantage of using Terraform to provision the GitLab project and pipeline was that the AWS Access Key, AWS Secret Access Key, Datadog API Key and Datadog APP Key need to be stored as GitLab CI/CD Environment variables and using
Terraform meant I could generate and save the AWS Access Keys and AWS Secret Access Keys during the `terraform apply` phase and I could get the  Datadog API Keys and Datadog APP Keys from AWS Parameter Store.  Overall using Terraform to
provision the GitLab project and pipeline meant it was easier and predictable to work with secrets.

# Testing

Once this solution is deployed it can be tested from the AWS Lambda console by going to the `automated-datadog-agent-upgrade` Lambda function and using the native **Test** functionality.

![Alt text](images/lambda-do-nothing.png?raw=true "Lambda output when latest agent version not approved")

![Alt text](images/lambda-do-something.png?raw=true "Lambda output when latest agent version is approved")

# New AWS Accounts

If a new AWS account needs to be incorporated into this module, here are the files that need to be modified:

* /variables.tf
* /terraform.tfvars
* /provider.tf
* /main.tf
* /modules/eb-lambda/main.tf
* /modules/ssm/variables.tf
* ~/.aws/config
* add three Parameter Store variables (DATADOG_SITE, DATADOG_API_KEY and DATADOG_APP_KEY)

# Helpful commands

## How to get a list of Datadog agent versions

```
curl -s https://api.github.com/repos/DataDog/datadog-agent/releases | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sort -rV
curl -s "https://api.github.com/repos/DataDog/datadog-agent/releases" | jq -r '.[].tag_name' | sort -rV
```

## How to install a specific version of the Datadog agent

```
export DD_API_KEY=<MY_DATADOG_API_KEY>
export DD_AGENT_MAJOR_VERSION=7
export DD_AGENT_MINOR_VERSION=63.2
export DD_SITE="datadoghq.com"
bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
```

or

```
export DD_API_KEY=<MY_DATADOG_API_KEY>
export DD_AGENT_MAJOR_VERSION=7
export DD_AGENT_MINOR_VERSION=63.2
export DD_SITE="datadoghq.com"
bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"
```

## Setup of Lambda Layer

```
cd ~/terraform/aws/automated-datadog-agent-upgrade/modules/eb_lambda
mkdir -p python/lib/python3.12/site-packages
pip install requests -t python/lib/python3.12/site-packages
zip -r artifacts/requests-layer.zip python
```

# To Do

### Create AWS IAM Role in each account that will be assumed by Lambda Function - DONE

### Follow Mike's example in https://gitlab.tecsysrd.cloud/ops/noc/iam-keys-rotation-check to deploy IAM Roles in all AWS accounts.

### Modify SSM Document so that is it shared to all AWS accounts - DONE

### Modify Lambda Function to call SSM Document in all AWS accounts - DONE

### Use Guilherme's dd-monitor-auto-mute Lambda function to Mute Datadog Monitor - IN PROGRESS

### Enhance with addition of SSM State Manager - DONE
