data "aws_ec2_transit_gateway" "canada" {
  id = var.transit_gateway_id
}

data "aws_dx_connection" "canada" {
  name     = var.direct_connect_name
}

resource "aws_dx_gateway" "canada" {
  name            = var.direct_connect_gw_name
  amazon_side_asn = "64512"
}

resource "aws_dx_gateway_association" "canada" {
  dx_gateway_id         = aws_dx_gateway.canada.id
  associated_gateway_id = data.aws_ec2_transit_gateway.canada.id

  allowed_prefixes = [
    "161.108.208.0/24",
    "161.108.90.0/24",
    "161.108.91.128/25"
  ]
}

# resource "aws_dx_transit_virtual_interface" "canada" {
#   provider      = aws.local
#   connection_id = data.aws_dx_connection.canada.id

#   dx_gateway_id  = aws_dx_gateway.canada.id
#   name           = "tf-transit-vif-canada"
#   vlan           = 308
#   address_family = "ipv4"
#   bgp_asn        = 65352
# }

output "dxcon_id" {
  value = data.aws_dx_connection.canada.id
}

output "dxcon_location" {
  value = data.aws_dx_connection.canada.location
}

output "dxcon_provider" {
  value = data.aws_dx_connection.canada.provider_name
}

output "dxcon_vlan_id" {
  value = data.aws_dx_connection.canada.vlan_id
}

output "dxgw_id" {
  value = aws_dx_gateway.canada.id
}

output "dxgw_assoc_id" {
  value = aws_dx_gateway_association.canada.id
}

output "dxgw_assoc_type" {
  value = aws_dx_gateway_association.canada.associated_gateway_type
}

output "dxgw_association_id" {
  value = aws_dx_gateway_association.canada.dx_gateway_association_id
}

output "dxgw_owner_account_association_id" {
  value = aws_dx_gateway_association.canada.dx_gateway_owner_account_id
}