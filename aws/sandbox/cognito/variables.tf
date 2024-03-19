variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "profile" {
  description = "AWS Profile"
  default     = "sandbox"
  type        = string
}

variable "cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Sandbox"
  type        = string
}

variable "creation_date" {
  description = "Creation Date"
  default     = "2023-02-03 10:30:00"
  type        = string
}

variable "created_by" {
  description = "Tool used to create resources"
  default     = "Terraform"
  type        = string
}

variable "account" {
  description = "Requester Account"
  default     = "655690556973"
  type        = string
}

variable "owner" {
  description = "Application Owner"
  default     = "Rama Pulivarthy"
  type        = string
}

variable "application" {
  description = "Application Name"
  default     = "CareGuard 3"
  type        = string
}

variable "s3_bucket" {
  description = "Cognito S3 Bucket"
  default     = "careguard-cognito-bucket"
  type        = string
}

variable "saml_file" {
  description = "Cognito IdP SAML Configuration File"
  default     = "compucom-saml.xml"
  type        = string
}

variable "user_pool_name" {
  description = "Cognito User Pool Name"
  default     = "careguard-test"
  type        = string
}

variable "user_pool_domain_name" {
  description = "Cognito User Pool Domain Name"
  default     = "cg3-angular-testing-bg"
  type        = string
}

variable "user_pool_app_client_name" {
  description = "Cognito User Pool App Client Name"
  default     = "testmfa"
  type        = string
}

variable "user_pool_resource_server_name" {
  description = "Cognito User Pool Resource Server Name"
  default     = "cg3-backend"
  type        = string
}

variable "r53_hosted_zone_id" {
  description = "The Route 53 Hosted Zone Id For careguard.net"
  default     = "Z18BORQC57TNAS"
  type        = string
}

variable "custom_domain_name" {
  description = "The custom domain name"
  default     = "authtest.careguard.net"
  type        = string
}

variable "certificate_arn" {
  description = "The ACM Certificate ARN for *.careguard.net"
  default     = "arn:aws:acm:us-east-1:300899438431:certificate/04617f26-a812-4fb8-91c8-e5f44761997d"
  type        = string
}