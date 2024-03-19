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

variable "ami_id" {
  description = "AMI Id"
  default     = "ami-04a0ae173da5807d3"
  type        = string
}

variable "instance_type" {
  description = "Instance Type"
  default     = "t3.micro"
  type        = string
}

variable "key_name" {
  description = "SSH Key Name"
  default     = "sssmdemo"
  type        = string
}

variable "security_group_ids" {
  description = "Security Group Ids"
  default     = ["sg-0d10ff66ca3715382"]
  type        = list(string)
}

variable "subnet_id" {
  description = "Subnet Id"
  default     = "subnet-3cc8344a"
  type        = string
}

variable "root_block_delete_on_termination" {
  description = "Delete On Termination"
  default     = "false"
  type        = string
}

variable "root_block_volume_size" {
  description = "EBS Size"
  default     = 50
  type        = string
}

variable "root_block_volume_type" {
  description = "EBS Type"
  default     = "gp3"
  type        = string
}