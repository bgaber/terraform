# Create Local Transit Gateway
resource "aws_ec2_transit_gateway" "local" {
  provider        = aws.local

  description     = "${var.transit_gateway_description} ${var.local_region}"
  amazon_side_asn = 64513
  auto_accept_shared_attachments = "enable"

  tags = {
    Name = "compucom-transit-gateway in ${var.local_region}"
  }
}

resource "aws_ram_resource_share" "canada" {
  provider = aws.local

  name = "OrganizationShare"

  tags = {
    Name = "OrganizationShare"
  }
}

# ... get Organization data
data "aws_organizations_organization" "compucom" {
  provider = aws.master
}

# Share the transit gateway ...
resource "aws_ram_resource_association" "canada" {
  provider           = aws.local

  resource_arn       = aws_ec2_transit_gateway.local.arn
  resource_share_arn = aws_ram_resource_share.canada.id
}

# ... with the entire organization.
resource "aws_ram_principal_association" "canada" {
  provider           = aws.local

  #principal          = var.organization_arn
  principal          = data.aws_organizations_organization.compucom.arn
  resource_share_arn = aws_ram_resource_share.canada.arn
}

# Create the VPC attachment in the local account (ca-central-1 region) ...
resource "aws_ec2_transit_gateway_vpc_attachment" "canada" {
  provider = aws.local

  depends_on = [
    aws_ram_principal_association.canada,
    aws_ram_resource_association.canada,
  ]

  transit_gateway_id = aws_ec2_transit_gateway.local.id

  for_each = {for i, v in var.vpc_attributes:  i => v}
    subnet_ids         = each.value.subnets
    vpc_id             = each.value.vpcid

    tags = {
      Name = "${each.value.name} Transit Gateway VPC Attachment"
      Side = "Creator"
    }
}

# ...and accept it in the local account (ca-central-1 region) ...
# attachment acceptance is only required for cross-account attachments
# resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "canada" {
#   provider = aws.local

#   for_each = {for i, v in var.vpc_attributes:  i => v}
#     transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.canada[each.key].id

#     tags = {
#       Name = "${each.value.name}  Transit Gateway VPC Attachment Accepter"
#       Side = "Accepter"
#     }
# }

# Reference Peer Region
data "aws_region" "peer" {
  provider = aws.peer
}

# Reference Peer Transit Gateway
data "aws_ec2_transit_gateway" "peer" {
  provider = aws.peer
  id = var.peer_transit_gateway_id
}

# Create the Peering attachments in the local account...
resource "aws_ec2_transit_gateway_peering_attachment" "canada" {
  provider = aws.local
  peer_account_id         = data.aws_ec2_transit_gateway.peer.owner_id
  peer_region             = data.aws_region.peer.name
  peer_transit_gateway_id = data.aws_ec2_transit_gateway.peer.id
  transit_gateway_id      = aws_ec2_transit_gateway.local.id

  tags = {
    Name = "TGW Peering Requestor to ${var.peer_region}"
  }
}

# ... and accept it in the peer account.
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "us" {
  provider = aws.peer
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.canada.id
  tags = {
    Name = "TGW Peering Acceptor from ${var.local_region}"
  }
}

output "local_tg_arn" {
  value = aws_ec2_transit_gateway.local.arn
}

output "peer_tg_arn" {
  value = data.aws_ec2_transit_gateway.peer.arn
}

output "local_tg_default_route_table_id" {
  value = aws_ec2_transit_gateway.local.association_default_route_table_id
}

output "local_tg_id" {
  value = aws_ec2_transit_gateway.local.id
}

output "peer_tg_id" {
  value = data.aws_ec2_transit_gateway.peer.id
}

output "local_tg_owner_id" {
  value = aws_ec2_transit_gateway.local.owner_id
}

output "peer_tg_owner_id" {
  value = data.aws_ec2_transit_gateway.peer.owner_id
}

output "local_tg_propagation_default_route_table_id" {
  value = aws_ec2_transit_gateway.local.propagation_default_route_table_id
}

output "peering_accepter_id" {
  value = aws_ec2_transit_gateway_peering_attachment_accepter.us.id
}

output "peering_accepter_local_tg_id" {
  value = aws_ec2_transit_gateway_peering_attachment_accepter.us.transit_gateway_id
}

output "peering_accepter_peer_tg_id" {
  value = aws_ec2_transit_gateway_peering_attachment_accepter.us.peer_transit_gateway_id
}

output "peering_accepter_peer_account_id" {
  value = aws_ec2_transit_gateway_peering_attachment_accepter.us.peer_account_id 
}

output "organization_arn" {
  value = data.aws_organizations_organization.compucom.arn
}

output "organization_id" {
  value = data.aws_organizations_organization.compucom.id
}

output "organization_master_account_arn" {
  value = data.aws_organizations_organization.compucom.master_account_arn
}

output "organization_master_account_id" {
  value = data.aws_organizations_organization.compucom.master_account_id
}

output "aws_ec2_transit_gateway_vpc_attachment_id" {
  value = values(aws_ec2_transit_gateway_vpc_attachment.canada)[*].id
}

# attachment acceptance is only required for cross-account attachments
# output "aws_ec2_transit_gateway_vpc_attachment_accepter_id" {
#   value = values(aws_ec2_transit_gateway_vpc_attachment_accepter.canada)[*].id
# }

# output "aws_ec2_transit_gateway_vpc_attachment_accepter_vpc_id" {
#   value = values(aws_ec2_transit_gateway_vpc_attachment_accepter.canada)[*].vpc_id
# }