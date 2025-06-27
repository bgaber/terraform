resource "aws_ssm_parameter" "secret" {
  for_each = var.parameters
  name  = each.key
  value = each.value
  #type = contains(lower(each.key), "password") ? "SecureString" : "String"
  
  # can() returns true if the regex() function runs without error (i.e., a match is found).
  # If there's no match, regex() would normally throw error, but can() swallows the error and returns false.
  type = can(regex("/password$", each.key)) ? "SecureString" : "String"
}

# output "aws_ssm_parameter_arn" {
#   value = values(aws_ssm_parameter.secret)[*].arn
# }

# output "parameters" {
#   value = aws_ssm_parameter.secret
# }

output "ssm_parameters" {
  value = {
    for k, v in aws_ssm_parameter.secret : k => v.name
  }
}