data "aws_ssm_parameter" "username" {
  name = var.username
}

data "aws_ssm_parameter" "password" {
  name = var.password
}

output "username_value" {
  #sensitive = true
  value = nonsensitive(data.aws_ssm_parameter.username.value)
}

output "password_value" {
  #sensitive = true
  value = nonsensitive(data.aws_ssm_parameter.password.value)
}
