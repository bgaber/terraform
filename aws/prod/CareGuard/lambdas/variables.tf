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

variable lambda_attributes {
  description = "List of Lambda Objects"
  type = list(object({
    name                  = string
    description           = string
    runtime               = string
    lambda_deployment_pkg = string
  }))
  default = [
    {
      name                  = "careguard-sn-device-update",
      description           = "Careguard device update function",
      runtime               = "nodejs20.x",
      lambda_deployment_pkg = "careguard-sn-device-update-389dad0b-3c72-42eb-b7f3-2685ad277972.zip"
    },
    {
      name                  = "careguard-sn-location-update",
      description           = "Careguard location update function",
      runtime               = "nodejs20.x",
      lambda_deployment_pkg = "careguard-sn-location-update-81fa174f-3c43-4660-8402-d139e70609f0.zip"
    },
    {
      name                  = "careguard-sn-ticket-update",
      description           = "Careguard ticket update Function",
      runtime               = "nodejs20.x",
      lambda_deployment_pkg = "careguard-sn-ticket-update-de3d2195-8d73-47ea-b34c-e8889982e65f.zip"
    }
  ]
}

variable "s3_bucket" {
  description = "Lambda Function Name"
  default     = "careguard-prod-iac-bucket"
  type        = string
}

variable "private_subnets" {
  type    = list(string)
  default = ["subnet-a1f61bc5", "subnet-c66df2ea"]
}

variable "security_groups" {
  type    = list(string)
  default = ["sg-f464a3bc"]
}