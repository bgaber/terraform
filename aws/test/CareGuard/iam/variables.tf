variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "profile" {
  description = "AWS Profile"
  default     = "test"
  type        = string
}

variable "cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}

variable "creation_date" {
  description = "Creation Date"
  default     = "2023-03-01 10:30:00"
  type        = string
}

variable "created_by" {
  description = "Who or what created these resources"
  default     = "Brian Gaber using Terraform"
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

variable "username" {
  description = "IAM User Name"
  default     = "careguard_for_bitbucket"
  type        = string
}


variable "ecs_task_role_name" {
  description = "Care Guard ECS Task Role Name"
  default     = "cg-ecs-task-role"
  type        = string
}

variable "ecs_task_exec_role_name" {
  description = "Care Guard ECS Task Execution Role Name"
  default     = "cg-ecs-execution-role"
  type        = string
}

variable "aws_account" {
  description = "The AWS Account for this deployment"
  default     = "300899438431"
  type        = string
}

variable "cloudfront_dist_id" {
  description = "CloudFront Distribution ID"
  default     = "E1DFZCGNU1GLB8"
  type        = string
}
