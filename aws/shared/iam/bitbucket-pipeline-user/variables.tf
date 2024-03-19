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
  default     = "2023-02-16 10:30:00"
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
  default     = "Jason Boomer"
  type        = string
}

variable "application" {
  description = "Application Name"
  default     = "BitBucket Pipelines"
  type        = string
}

variable "username" {
  description = "BitBucket IAM Username"
  default     = "bitbucket_pipelines_test"
  type        = string
}