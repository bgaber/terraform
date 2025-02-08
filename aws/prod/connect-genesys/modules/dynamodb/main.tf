resource "aws_dynamodb_table" "connect_genesys_dynamodb" {
  name             = var.table_name
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key         = "botSessionId"

  attribute {
    name = "botSessionId"
    type = "S"
  }

  ttl {
    attribute_name = "TTL"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }
  table_class = "STANDARD"
}

output "connect_genesys_table" {
  value = aws_dynamodb_table.connect_genesys_dynamodb.arn
}

output "db_arn" {
  value = aws_dynamodb_table.connect_genesys_dynamodb.arn
}
