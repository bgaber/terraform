variable "local_region" {
  description = "AWS Region"
  default     = "ca-central-1"
  type        = string
}

variable "canada_cred_profile" {
  description = "AWS Profile"
  default     = "CA-Prod"
  type        = string
}

variable "peer_region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "shared_cred_profile" {
  description = "AWS Profile"
  default     = "Shared"
  type        = string
}

variable "master_cred_profile" {
  description = "AWS Profile"
  default     = "US-Master"
  type        = string
}

variable "organization_arn" {
  description = "Transit Gateway Description"
  default     = "arn:aws:organizations::534825570336:account/o-4u8cmsb1bb"
  type        = string
}

variable "transit_gateway_description" {
  description = "Transit Gateway Description"
  default     = "Main transit gateway for all Compucom AWS traffic routing in"
  type        = string
}

variable "peer_transit_gateway_id" {
  description = "Peer Transit Gateway Id"
  default     = "tgw-021d267f84359f0ab"
  type        = string
}

variable vpc_attributes {
  description = "Map of VPC attributes"
  type = list(object({
    name  = string
    vpcid = string
    subnets  = list(string)
  }))
  default = [
    {
      name  = "Canada Production",
      vpcid = "vpc-8ae1c9e3",
      subnets  = ["subnet-0697caaeaad726861", "subnet-07c2b6653290789ae"]
    },
    {
      name  = "SPOG",
      vpcid = "vpc-3778ca5f",
      subnets  = ["subnet-74e04a1c", "subnet-d47cbbae"]
    },
    {
      name  = "IIROC",
      vpcid = "vpc-04348367344d98757",
      subnets  = ["subnet-00bbb475cb772eacd", "subnet-0234acf0cbd140349"]
    },
    {
      name  = "Canada Cloud Transformation UHN",
      vpcid = "vpc-08fe1dd721e09e558",
      subnets  = ["subnet-09347547368fcdbcc", "subnet-0bc2651982e6dfd81"]
    }
  ]
}