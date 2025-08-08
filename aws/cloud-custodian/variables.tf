variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "go_noc_rd_profile" {
  description = "AWS Credential File Profile"
  default     = "go-noc-rd"
  type        = string
}

variable "rd_dev_k8s_profile" {
  description = "AWS Credential File Profile"
  default     = "rd-dev-k8s"
  type        = string
}

variable "go_prod_soc_profile" {
  description = "AWS Credential File Profile"
  default     = "go-prod-soc"
  type        = string
}
