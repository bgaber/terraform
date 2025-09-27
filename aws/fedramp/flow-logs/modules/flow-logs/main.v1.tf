data "aws_vpcs" "all" {}

data "aws_vpc" "detail" {
  for_each = toset(data.aws_vpcs.all.ids)
  id       = each.value
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
