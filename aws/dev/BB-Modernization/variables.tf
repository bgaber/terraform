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
  default     = "2023-02-25 10:30:00"
  type        = string
}

variable "created_by" {
  description = "Who or what created these resources"
  default     = "Brian Gaber using Terraform"
  type        = string
}

variable "owner" {
  description = "Application Owner"
  default     = "Mike Legato"
  type        = string
}

variable "application" {
  description = "Application Name"
  default     = "BB Modernization"
  type        = string
}

variable "instance_type" {
  description = "Enter mq.t2.micro, mq.t3.micro, mq.m4.large, mq.m5.large, mq.m5.xlarge, mq.m5.2xlarge or mq.m5.4xlarge. Default is mq.m5.xlarge."
  default     = "mq.m5.xlarge"
  type        = string
}

variable "mq_priv_subnets" {
  description = "Amazon MQ Private Subnets"
  default     = ["subnet-16d58e4e", "subnet-bc5d0496"]
  type        = list(string)
}

variable "security_group_name" {
  description = "Name of Security Group"
  default     = "bb-modernization-amazon-mq-dev"
  type        = string
}

variable "vpc_id" {
  description = "Test VPC"
  default     = "vpc-15df6372"
  type        = string
}

variable "username" {
  description = "An ActiveMQ user is a person or an application that can access the queues and topics of an ActiveMQ broker."
  default     = "fudde"
  type        = string
}

variable "password" {
  description = "Password of the ActiveMQ user"
  default     = "Password1234"
  type        = string
}

variable "aws_account" {
  description = "The AWS Account for this deployment"
  default     = "995437807815"
  type        = string
}