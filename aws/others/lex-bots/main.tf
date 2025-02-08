# As of Sep 2023 Terraform does not support Lexv2
# https://github.com/hashicorp/terraform-provider-aws/issues/21375
data "aws_lexv2models_bot" "lex_v2_bot" {
  name    = var.lex_bot_name
  version = var.lex_bot_alias
}

output "aws_lex_bot_id" {
  value = data.aws_lex_bot.lex_v2_bot.id
}