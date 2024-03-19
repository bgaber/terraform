data "aws_ec2_transit_gateway" "existing" {
  id = var.existing_transit_gateway_id
}

resource "aws_customer_gateway" "compucom_backup" {
  bgp_asn     = var.cgw_bgp_asn
  device_name = "CompuCom Shared Services CGW2_TG"
  ip_address  = var.cgw_ip_address
  type        = "ipsec.1"
  tags = {
    Name = "CompuCom Shared Services CGW2_TG"
  }
}

resource "aws_vpn_connection" "compucom_backup" {
  customer_gateway_id = aws_customer_gateway.compucom_backup.id
  transit_gateway_id  = data.aws_ec2_transit_gateway.existing.id
  type                = aws_customer_gateway.compucom_backup.type
  tags = {
    Name = "On-Prem-TG-VPN-Backup"
  }
}

output "aws_ec2_transit_gateway_description" {
  value = data.aws_ec2_transit_gateway.existing.description
}

output "aws_ec2_transit_gateway_arn" {
  value = data.aws_ec2_transit_gateway.existing.arn
}

output "aws_ec2_transit_gateway_owner_id" {
  value = data.aws_ec2_transit_gateway.existing.owner_id
}

output "aws_ec2_transit_gateway_association_default_route_table_id" {
  value = data.aws_ec2_transit_gateway.existing.association_default_route_table_id
}

output "aws_ec2_transit_gateway_propagation_default_route_table_id" {
  value = data.aws_ec2_transit_gateway.existing.propagation_default_route_table_id
}

output "aws_ec2_transit_gateway_tags" {
  value = data.aws_ec2_transit_gateway.existing.tags
}

output "aws_ec2_transit_gateway_transit_gateway_cidr_blocks" {
  value = data.aws_ec2_transit_gateway.existing.transit_gateway_cidr_blocks
}

output "aws_customer_gateway_arn" {
  value = aws_customer_gateway.compucom_backup.arn
}

output "aws_vpn_connection_arn" {
  value = aws_vpn_connection.compucom_backup.arn
}