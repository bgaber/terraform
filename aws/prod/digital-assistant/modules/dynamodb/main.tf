resource "aws_dynamodb_table" "digital_assistant_dynamodb" {
  name             = var.table_name
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key         = "SessionId"

  attribute {
    name = "SessionId"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
  table_class = "STANDARD"
}

output "digital_assistant_table" {
  value = aws_dynamodb_table.digital_assistant_dynamodb.arn
}

output "db_arn" {
  value = aws_dynamodb_table.digital_assistant_dynamodb.arn
}
