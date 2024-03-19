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
      Created     = "24 Nov 2022"
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

data "aws_vpc" "accepter" {
    provider = aws.accepter
    id       = "${var.accepter_vpc_id}"
}

locals {
    accepter_account_id = "${element(split(":", data.aws_vpc.accepter.arn), 4)}"
}

resource "aws_vpc_peering_connection" "requester" {
  vpc_id        = "${var.requester_vpc_id}"
  peer_vpc_id   = "${data.aws_vpc.accepter.id}"
  peer_owner_id = "${local.accepter_account_id}"

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
#     Created  = "24 Nov 2022"
#     Creator  = "Brian Gaber"
#   }
# }

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