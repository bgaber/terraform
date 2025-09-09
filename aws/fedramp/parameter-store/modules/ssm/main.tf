resource "aws_ssm_parameter" "secret" {
  for_each    = var.parameters
  #name        = join("/", ["","crowdstrike", each.key])
  name = startswith(each.key, "FALCON") ? "/crowdstrike/${each.key}" : "${each.key}"
  type        = "SecureString"
  value       = each.value
  #overwrite   = true

# https://spacelift.io/blog/terraform-ignore-changes
  lifecycle {
    ignore_changes = [value]
  }
}

output "aws_ssm_parameter_arn" {
  value = values(aws_ssm_parameter.secret)[*].arn
}