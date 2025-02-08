variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "us-dev"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Dev"
  type        = string
}

variable "vpc_id" {
  description = "Dev 10.251.32.0/20 CIDR VPC"
  default     = "vpc-87e65ae0"
  type        = string
}

variable "username" {
  description = "Postgres master username"
  default     = "postgres"
  type        = string
}

variable "password" {
  description = "Postgres master password"
  default     = "Postgres1234"
  type        = string
}

variable "rds_cluster_id" {
  description = "Postgres Cluster ID"
  default     = "awx-dev"
  type        = string
}

variable "rds_instance_id" {
  description = "Postgres Instance ID"
  default     = "awx-dev"
  type        = string
}