variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "ami_id" {
  description = "AMI Id"
  default     = "ami-0cf10cdf9fcd62d37"
  type        = string
}

variable "instance_type" {
  description = "Instance Type"
  default     = "t3.micro"
  type        = string
}

variable "key_name" {
  description = "SSH Key Name"
  default     = "sharedprovisioning"
  type        = string
}

variable "security_group_ids" {
  description = "Security Group Ids"
  default     = ["sg-0251aa15b81697647", "sg-02974f913553467e6", "sg-0c0f71f493bb723d7", "sg-0009c04d83aa54205", "sg-f1d1288b"]
  type        = list(string)
}

variable "subnet_id" {
  description = "Subnet Id"
  default     = "subnet-52474e24"
  type        = string
}

variable "root_block_delete_on_termination" {
  description = "Delete On Termination"
  default     = "true"
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