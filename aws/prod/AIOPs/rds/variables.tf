variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "us-prod"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}

variable "vpc_id" {
  description = "Prod 10.251.16.0/20 CIDR VPC"
  default     = "vpc-cde65aaa"
  type        = string
}

variable "username" {
  description = "Postgres master username"
  default     = "awx"
  type        = string
}

variable "password" {
  description = "Postgres master password"
  default     = ""
  type        = string
}

variable "rds_cluster_id" {
  description = "Postgres Cluster ID"
  default     = "aiops-awx-pdb01"
  type        = string
}

variable "rds_instance_id" {
  description = "Postgres Instance ID"
  default     = "aiops-awx-pdb01"
  type        = string
}

variable "database_name" {
  description = "AWX Database Name"
  default     = "awx"
  type        = string
}