variable "prod_region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "dr_region" {
  description = "AWS Region"
  default     = "us-west-2"
  type        = string
}

variable "vpc_id" {
  description = "VPC Id"
  default     = "vpc-09d0f14f0a4d5a5f6"
  type        = string
}

variable "cloud_watch_group_name" {
  description = "CloudWatch Group Name"
  default     = "/connect/ecs"
  type        = string
}

variable "ecr_name" {
  description = "ECR Name"
  default     = "connect"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  default     = "connect-cluster-prod"
  type        = string
}

variable "ecs_svc_name" {
  description = "ECS Service Name"
  default     = "connect-service-prod"
  type        = string
}

variable "ecs_task_family_name" {
  description = "ECS Task Definition Family Name"
  default     = "connect-task-prod"
  type        = string
}

variable "private_subnets" {
  type    = list(string)
  default = ["subnet-099ce569f71a5a8fe", "subnet-03d7dda52aa2da40b"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["subnet-0e02192b9bf301d62", "subnet-0da123f67e20073e7"]
}

variable "elb_name" {
  description = "ELB Name"
  default     = "connect-lb-prod"
  type        = string
}

variable "elb_certificate" {
  description = "ELB Certificate"
  default     = "arn:aws:acm:us-east-1:122639376858:certificate/21345f26-f51c-4d0e-b8dd-5d16bbb776c2"
  type        = string
}