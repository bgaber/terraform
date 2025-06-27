variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "elite_passwd_rotation_service_account" {
  description = "Elite Password Rotation Service Account"
  default     = "elite-password-rotation-sa"
  type        = string
}

variable "s3_bucket_name" {
  description = "Lambda Archives For Terraform"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda Function Name"
  type        = string
}

variable "lambda_deployment_pkg" {
  description = "Lambda Deployment Package"
  type        = string
}

variable "elite_passwd_rotation_gitlab_repo_id" {
  description = "Elite Password Rotation GitLab Project Id"
  default     = "22884"
  type        = string
}