resource "aws_cloudwatch_log_group" "connect" {
  for_each = toset(var.lex_bot_names)
  name     = join("/", ["", "connect", "lex", each.value])
}

output "aws_cloudwatch_log_group_arn" {
  value = values(aws_cloudwatch_log_group.connect)[*].arn
}

# data "aws_lex_bot" "connect_bot" {
#   for_each   = toset(var.lex_bot_names)
#   name       = each.value
# }

# output "aws_lex_bot_arn" {
#   value    = data.aws_lex_bot.connect_bot[*].arn
# }

# output "aws_lex_bot_name" {
#   value    = data.aws_lex_bot.connect_bot[*].name
# }

# output "aws_lex_bot_status" {
#   value    = data.aws_lex_bot.connect_bot[*].status
# }

# data "aws_lex_bot_alias" "connect_bot" {
#   for_each   = toset(var.lex_bot_names)
#   bot_name   = each.value
#   name       = "TestBotAlias"
# }

# output "aws_lex_bot_alias_arn" {
#   value    = data.aws_lex_bot_alias.connect_bot[*].arn
# }

# output "aws_lex_bot_alias_name" {
#   value    = data.aws_lex_bot_alias.connect_bot[*].bot_name
# }