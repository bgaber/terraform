variable "prod_region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "ecr_name" {
  description = "ECR Name"
  default     = "genesys-chat-translator"
  type        = string
}