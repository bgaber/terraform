resource "aws_ssm_parameter" "secret" {
  for_each = var.parameters
  name     = join("/", ["","crowdstrike", each.key])
  type     = "SecureString"
  value    = each.value
}

output "aws_ssm_parameter_arn" {
  value = values(aws_ssm_parameter.secret)[*].arn
}