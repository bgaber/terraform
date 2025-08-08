# FED-1070: Unused credentials should be deactivated or removed

![AWS IAM](https://img.shields.io/badge/AWS-IAM-orange?logo=aws)
![Terraform](https://img.shields.io/badge/Terraform-Applied-brightgreen?logo=crowdstrike)
![Cloud Custodian](https://img.shields.io/badge/Cloud%20Custodian-Enabled-blueviolet)

# Overview

The purpose of this solution is to automatically deactivate unused AWS user credentials using Cloud Custodian.

# Setup

This section explains any components that require a substantial setup.

## AWS Credential Profiles Setup required by Terraform for multi-account installation of Cloud Custodian IAM Permissions

In order for this Terraform module to provision the IAM resources on every FedRAMP AWS account a AWS config file needs to be created that works with AWS Identity Center.
At the time this document was written there were 14 FedRAMP AWS accounts and the following is the `~/.aws/config` required for these accounts:

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

[profile fedramp-network]
sso_session = fedramp-session
sso_account_id = 445567083790
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile fedramp-network-prd]
sso_session = fedramp-session
sso_account_id = 104299473261
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
https://d-9067d80a1d.awsapps.com/start/#/device?user_code=ZWSV-FKLQ
```

3.  Your browser should output something like this:

![Alt text](images/aws-sso-login-1.png?raw=true "First browser response")
![Alt text](images/aws-sso-login-2.png?raw=true "Second browser response")
![Alt text](images/aws-sso-login-3.png?raw=true "Third browser response")

At this point you should be able to run an AWS CLI command on any of the FedRAMP AWS accounts.  For example:

```
aws s3 ls --profile fedramp-tools
```

The profile must match one of the the profile values in the AWS config file above.

## Infrastructure as Code (IaC) Deployment

This entire solution was provisioned to AWS using Terraform.

### Prerequisites environment variables required to run:

Set this GitLab environment variable:

```bash
export GITLAB_TOKEN=
```

## Steps to provision solution on AWS

1. Install Terraform onto the same computer where you have setup the AWS SSO Credential Profiles described above
2. Clone this repository
3. Run the following Terraform commands:
```
terraform init
terraform validate
terraform plan
terraform apply --auto-approve
```

### Contribution guidelines ###

* NOC SRE team members are welcome to contribute

### Who do I talk to? ###

* Repository owner is Brian Gaber
