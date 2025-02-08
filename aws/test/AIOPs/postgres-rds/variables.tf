variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "login_profile" {
  description = "AWS Profile"
  default     = "us-test"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}

variable "vpc_id" {
  description = "Test 10.251.48.0/20 CIDR VPC"
  default     = "vpc-15df6372"
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
  #default     = "aiops-awx-tdb01"
  default     = "aiops-awx-pg13"
  type        = string
}

variable "rds_instance_id" {
  description = "Postgres Instance ID"
  #default     = "aiops-awx-tdb01"
  default     = "aiops-awx-pg13"
  type        = string
}

variable "database_name" {
  description = "AWX Database Name"
  default     = "awx"
  type        = string
}

variable "postgres_version" {
  description = "PostgreSQL Version (15.6, 14.11 or 13.14)"
  default     = "13.14"
  type        = string
}