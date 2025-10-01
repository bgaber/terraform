variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "aws_accounts" {
  description = "A map of AWS account names to their respective CLI profile names"
  type        = map(string)
}
