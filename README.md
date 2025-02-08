# Terraform #

Brief steps to deploying Terraform IAC code

### What is this repository for? ###

* This repository is for Cloud Ops SRE team Terraform code
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

* The AWS CLI v2 must be installed and configured
* Install Terraform
* In order for Terraform to deploy to an AWS account one of two methods may be used:

1. the `AWS_PROFILE` environment variable may be set, for example:

```bash
export AWS_PROFILE=US-Dev
```

2. or include 'profile =' in the provider section of your terraform (.tf) file, for example:

```bash
provider "aws" {
  region = "us-east-1"
  profile = "US-Dev"
}
```

### Typical sequence of Terraform deployment steps ###
* terraform fmt
* terraform init
* terraform validate
* terraform plan
* terraform apply

### Work with Terraform state ###
* terraform state list
* terraform state show <resource>

### Useful Terraform debugging environment variables ###
* TF_LOG, e.g. `export TF_LOG=trace`
* TF_LOG_PATH, e.g. `export TF_LOG_PATH=terraform.log`

### Contribution guidelines ###

* Cloud Ops SRE team members are welcome to contribute

### Who do I talk to? ###

* Repo owner is Brian Gaber