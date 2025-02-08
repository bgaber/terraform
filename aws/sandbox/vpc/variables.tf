variable "CreationDate" {
  type = string
  default = "2022-11-17 10:30:00"
  description = "Creation Date"
}

variable "Creator" {
  type = string
  default = "Terraform"
  description = "Name of Creator"
}

variable "Customer" {
  type = string
  default = "UHN"
  description = "Customer Name"
}

variable "VPCName" {
  type = string
  default = "Canada Cloud Transformation UHN VPC"
  description = "VPC Name"
}

variable "cidr_ip" {
  type = string
  default = "192.168.131.0/24"
  description = "The VPC CIDR Block"

  validation {
    condition     = can(cidrnetmask(var.cidr_ip))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "PublicSubnet1" {
  type = string
  default = "Canada Cloud Transformation UHN Public1"
  description = "First Public Subnet"
}

variable "pub_sub_ip1" {
  type = string
  default = "192.168.131.128/26"
  description = "Public Subnet 1"

  validation {
    condition     = can(cidrnetmask(var.pub_sub_ip1))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "PublicSubnet2" {
  type = string
  default = "Canada Cloud Transformation UHN Public2"
  description = "Second Public Subnet"
}

variable "pub_sub_ip2" {
  type = string
  default = "192.168.131.192/26"
  description = "Public Subnet 2"

  validation {
    condition     = can(cidrnetmask(var.pub_sub_ip2))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "PrivateSubnet1" {
  type = string
  default = "Canada Cloud Transformation UHN Private1"
  description = "First Private Subnet"
}

variable "priv_sub_ip1" {
  type = string
  default = "192.168.131.0/26"
  description = "Private Subnet 1"

  validation {
    condition     = can(cidrnetmask(var.priv_sub_ip1))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "PrivateSubnet2" {
  type = string
  default = "Canada Cloud Transformation UHN Private2"
  description = "Second Private Subnet"
}

variable "priv_sub_ip2" {
  type = string
  default = "192.168.131.64/26"
  description = "Private Subnet 2"

  validation {
    condition     = can(cidrnetmask(var.priv_sub_ip2))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "PublicRouteDescription" {
  type = string
  default = "Canada Cloud Transformation UHN Public RT"
  description = "Public Route Table"
}

variable "PrivateRouteDescription" {
  type = string
  default = "Canada Cloud Transformation UHN Private RT"
  description = "Private Route Table"
}

variable "vgw_asn" {
  type = string
  description = "VGW Amazon Side ASN (e.g. 65412)"

  validation {
        condition = can(regex("^([0-9]{4,8})$",var.vgw_asn))
        error_message = "Invalid Autonomous System Number (ASN) provided."
    }
}

variable "IGWrequired" {
  type = string
  default = "No"
  description = "Internet Gateway Choice"
}

variable "VGWrequired" {
  type = string
  default = "Yes"
  description = "VPN Gateway Choice"
}

variable "NATGWrequired" {
  type = string
  default = "No"
  description = "NAT Gateway Choice"
}