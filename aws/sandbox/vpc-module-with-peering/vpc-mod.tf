terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.39"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.requester_cred_profile
  default_tags {
    tags = {
      Created     = "25 Nov 2022"
      Creator     = "Brian Gaber"
      Environment = "Dev"
      Owner       = "Brian Gaber"
      IAC_Tool    = "Terraform"
    }
  }
}

provider "aws" {
  alias   = "accepter"
  region  = var.region
  profile = var.accepter_cred_profile
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "brian-vpc"
  cidr = "192.168.131.0/24"
  amazon_side_asn = "64512"
  #propagate_intra_route_tables_vgw = true
  propagate_private_route_tables_vgw = true

  azs             = ["us-east-1a", "us-east-1b"]
  #vpn_gateway_az  = "us-east-1b"
  private_subnets = ["192.168.131.0/26", "192.168.131.64/26"]
  public_subnets  = ["192.168.131.128/26", "192.168.131.192/26"]

  create_database_internet_gateway_route = false
  create_database_nat_gateway_route = false
  create_database_subnet_group = false
  create_database_subnet_route_table = false
  create_egress_only_igw = false
  create_elasticache_subnet_group = false
  create_elasticache_subnet_route_table = false
  create_flow_log_cloudwatch_iam_role = false
  create_flow_log_cloudwatch_log_group = false
  create_igw = false
  create_redshift_subnet_group = false
  create_redshift_subnet_route_table = false
  create_vpc = true

  enable_dhcp_options = true
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_flow_log = false
  enable_ipv6 = false
  enable_nat_gateway = false
  enable_public_redshift = false
  enable_vpn_gateway = true

  tags = {
    Created     = "25 Nov 2022"
    Creator     = "Brian Gaber"
    Terraform   = "true"
    Environment = "dev"
    Owner       = "Brian Gaber"
  }
}

data "aws_vpc" "accepter" {
    provider = aws.accepter
    id       = "${var.accepter_vpc_id}"
}

locals {
    accepter_account_id = "${element(split(":", data.aws_vpc.accepter.arn), 4)}"
}

resource "aws_vpc_peering_connection" "requester" {
  vpc_id        = module.vpc.vpc_id
  peer_vpc_id   = data.aws_vpc.accepter.id
  peer_owner_id = local.accepter_account_id

  tags = {
    Name     = "peer_to_${var.accepter_profile}"
  }
}

# resource "aws_vpc_peering_connection_accepter" "accepter" {
#   provider                  = aws.accepter
#   vpc_peering_connection_id = aws_vpc_peering_connection.requester.id
#   auto_accept               = false

#   tags = {
#     Name     = "peer_to_${var.requester_profile}"
#     Created  = "25 Nov 2022"
#     Creator  = "Brian Gaber"
#   }
# }

output "new_vpc_arn" {
  value = module.vpc.vpc_arn
}

output "new_vpc_id" {
  value = module.vpc.vpc_id
}

output "accepter_vpc_id" {
  value = data.aws_vpc.accepter.id
}

output "accepter_vpc_arn" {
  value = data.aws_vpc.accepter.arn
}

output "accepter_account" {
  value = local.accepter_account_id
}

output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection.requester.id
}