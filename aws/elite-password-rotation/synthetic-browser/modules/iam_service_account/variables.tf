variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "elite_passwd_rotation_service_account" {
  description = "Elite Password Rotation Parameter Store Service Account"
  default     = "elite-password-rotation-parameter-store-sa"
  type        = string
}