# Retrieve the current AWS account ID
data "aws_caller_identity" "current" {}

# Get all VPCs in the region
data "aws_vpcs" "all" {}

# Get details for each VPC
data "aws_vpc" "detail" {
  for_each = toset(data.aws_vpcs.all.ids)
  id       = each.value
}
locals {
  # Map AWS account ID to destination S3 bucket ARN
  account_s3_arns = {
    "438979369891" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-agencysim-npri"
    "491085412189" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-edgenw-npr"
    "761018876945" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-edgenw-npri"
    "120569617426" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-edgenw-prd"
    "686255941416" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-integration-npr"
    "311141548321" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-integration-npri"
    "528757785295" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-integration-prd"
    "054037137415" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-k8s-npr"
    "202533508444" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-k8s-npri"
    "816069130447" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-k8s-prd"
    "445567083790" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-network"
    "104299473261" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-network-prd"
    "980921753767" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-security"
    "897722679597" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-tools-npri"
    "195665324256" = "arn:aws:s3:::tecsysfed-crowdstrike-fedramp-tools-prd"
  }

  # Build a set of VPC IDs that do NOT have "default" in their Name tag
  vpc_ids_no_default = [
    for vpc_id, vpc in data.aws_vpc.detail :
      vpc_id
    #if !contains(lower(lookup(vpc.tags, "Name", "")), "default")
    if !can(regex("default", lower(lookup(vpc.tags, "Name", ""))))
  ]
}

# Create a flow log for each qualifying VPC
resource "aws_flow_log" "for_vpcs" {
  for_each               = toset(local.vpc_ids_no_default)
  vpc_id                 = each.value
  log_destination        = "${local.account_s3_arns[data.aws_caller_identity.current.account_id]}/ngs-flowlogs"
  log_destination_type   = "s3"
  traffic_type           = "ALL"
}


# Output just the IDs
output "vpc_ids" {
  value = data.aws_vpcs.all.ids
}

# Output map of the IDs and ARNs
output "vpc_id_arn_map" {
  value = {
    for vpc_id, vpc in data.aws_vpc.detail : vpc_id => vpc.arn
  }
}

# Output list of the IDs and ARNs
output "vpcs_id_arn_name" {
  value = [
    for vpc in data.aws_vpc.detail :
    {
      id   = vpc.id
      arn  = vpc.arn
      name = lookup(vpc.tags, "Name", null)
    }
  ]
}

output "current_flow_log_s3_arn" {
  value = local.account_s3_arns[data.aws_caller_identity.current.account_id]
}
