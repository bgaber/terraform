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
  default     = "2023-02-06 10:30:00"
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
  default     = "Paul Tams"
  type        = string
}

variable "application" {
  description = "Application Name"
  default     = "Data Science Machine Learning"
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
  default     = "machine-learning-dev"
  type        = string
}

variable "rds_instance_id" {
  description = "Postgres Instance ID"
  default     = "machine-learning-dev"
  type        = string
}