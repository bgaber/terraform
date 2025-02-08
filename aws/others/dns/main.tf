data "aws_ssm_parameter" "username" {
  name = var.username
}

data "aws_ssm_parameter" "password" {
  name = var.password
}

resource "dns_a_record_set" "compucom" {
  zone = "compucom.local."
  name = var.dns_name
  addresses = [
    "206.160.86.99"
  ]
  ttl = 300
}

output "username_value" {
  #sensitive = true
  #value = data.aws_ssm_parameter.username.value
  value = nonsensitive(data.aws_ssm_parameter.username.value)
}

output "password_value" {
  sensitive = true
  value = data.aws_ssm_parameter.password.value
  #value = nonsensitive(data.aws_ssm_parameter.password.value)
}
