variable "region" {
  description = "AWS Region"
  default     = "us-west-2"
  type        = string
}

variable "login_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Prod"
  type        = string
}

variable "route53_cred_profile" {
  description = "AWS Credential File Profile"
  default     = "Shared"
  type        = string
}

variable "vpc_id" {
  description = "VPC Id"
  default     = "vpc-08714c07ab0f42297"
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
  default     = "connect-cluster-prod-dr"
  type        = string
}

variable "ecs_svc_name" {
  description = "ECS Service Name"
  default     = "connect-service-prod-dr"
  type        = string
}

variable "ecs_task_family_name" {
  description = "ECS Task Name"
  default     = "connect-task-prod-dr"
  type        = string
}

variable "private_subnets" {
  type    = list(string)
  default = ["subnet-05c7d960a50f10fe0", "subnet-05e053d6be070578b"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["subnet-04e302aec1f41d9d7", "subnet-06fe73ff02dca1015"]
}

variable "elb_name" {
  description = "ELB Name"
  default     = "connect-lb-prod-dr"
  type        = string
}

variable "elb_certificate" {
  description = "ELB Certificate"
  default     = "arn:aws:acm:us-west-2:122639376858:certificate/1b0f1e55-9129-46f6-93c2-ae983cb64d8a"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID for compucom.com"
  default     = "Z064264889QSPIPW16Y"
  type        = string
}