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

### TEXT TO BE ADDED

# Infrastructure as Code (IaC) Deployment

This entire solution was provisioned to AWS using Terraform.

### Prerequisites environment variables required to run:

Set this GitLab environment variable:

```bash
export GITLAB_TOKEN=
```

Set these AWS environment variables:

```bash
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
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
