variable "linux_ssm_document_name" {
  description = "Linux SSM Document Name"
  type        = string
}

variable "windows_ssm_document_name" {
  description = "Windows SSM Document Name"
  type        = string
}

variable "s3_output_location" {
  description = "S3 Bucket Log Output Location"
  type        = string
  default     = "brian-gaber-ng-siem-test"
}