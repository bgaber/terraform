resource "aws_lexv2models_bot" "connect" {
  for_each = toset(var.lex_bot_names)
  name = each.value
  data_privacy {
    child_directed = false
  }
  idle_session_ttl_in_seconds = 1800
  role_arn                    = var.lex_role_arn
}

output "aws_lexv2models_bot_id" {
  value = values(aws_lexv2models_bot.connect)[*].id
}