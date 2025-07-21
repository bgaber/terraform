locals {
  existing_parameters = {
    for key, value in var.parameters :
    key => can(data.aws_ssm_parameter.secret[key].id) ? true : false
  }
}

# Output for skipped parameters
output "existing_parameters" {
  value = local.existing_parameters
}