data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id

    # Use same map in both resources
  attributes_map = { 
    for attribute in var.lambda_attributes : 
    attribute.name => attribute 
  }
}

data "aws_iam_policy_document" "trusted_entity" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role_for_lambda" {
  for_each = local.attributes_map
  name               = "connect_genesys_lambda_role_${each.value.name}"
  assume_role_policy = data.aws_iam_policy_document.trusted_entity.json
}

resource "aws_lambda_layer_version" "genesys_post_utterance_layer" {
  s3_bucket  = var.s3_bucket
  s3_key     = var.genesys_post_utterance_layer_pkg
  layer_name = "genesys_post_utterance_layer"

  compatible_runtimes = ["nodejs20.x"]
}

resource "aws_lambda_layer_version" "create_self_ticket_service_layer" {
  s3_bucket  = var.s3_bucket
  s3_key     = var.create_self_ticket_service_layer_pkg
  layer_name = "create_self_ticket_service_layer"

  compatible_runtimes = ["nodejs20.x"]
}

resource "aws_lambda_function" "connect_genesys" {
  for_each      = local.attributes_map
  function_name = each.value.name
  description   = each.value.description
  role          = aws_iam_role.role_for_lambda[each.key].arn
  handler       = var.lambda_handler
  layers        = (each.value.name == "genesys-post-utterance") ? [aws_lambda_layer_version.genesys_post_utterance_layer.arn] : (each.value.name == "create_self_ticket_service") ? [aws_lambda_layer_version.create_self_ticket_service_layer.arn] : [""]

  s3_bucket     = var.s3_bucket
  s3_key        = each.value.lambda_deployment_pkg

  runtime       = each.value.runtime
  timeout       = each.value.timeout

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs_policy,
    aws_cloudwatch_log_group.connect_genesys,
  ]

# https://spacelift.io/blog/terraform-ignore-changes
  lifecycle {
    ignore_changes = [
      environment,
    ]
  }
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "connect_genesys" {
  for_each          = local.attributes_map
  name              = "/aws/lambda/${each.value.name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "connect_genesys_lambda_logging"
  path        = "/"
  description = "IAM policy for logging from Connect Genesys lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  for_each   = local.attributes_map
  role       = aws_iam_role.role_for_lambda[each.key].name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy" {
  for_each   = local.attributes_map
  role       = aws_iam_role.role_for_lambda[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# Extra Translate and Lex permissions for the connect_genesys_lambda_role_genesys-post-utterance IAM Role
resource "aws_iam_role_policy_attachment" "translate_ro_access" {
  role       = "connect_genesys_lambda_role_genesys-post-utterance"
  policy_arn = "arn:aws:iam::aws:policy/TranslateReadOnly"
}

data "aws_iam_policy_document" "custom_lex_access" {
  statement {
    effect = "Allow"

    actions = [
      "lex:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "custom_lex_access" {
  name        = "connect_genesys_custom_lex_access"
  path        = "/"
  description = "IAM policy for Connect Genesys Custom Lex Access"
  policy      = data.aws_iam_policy_document.custom_lex_access.json
}

resource "aws_iam_role_policy_attachment" "custom_lex_access" {
  role       = "connect_genesys_lambda_role_genesys-post-utterance"
  policy_arn = aws_iam_policy.custom_lex_access.arn
}

# resource "aws_iam_role_policy_attachment" "lex_full_access_access" {
#   role       = "connect_genesys_lambda_role_genesys-post-utterance"
#   policy_arn = "arn:aws:iam::aws:policy/AmazonLexFullAccess"
# }

output "aws_lambda_function_arn" {
  value = values(aws_lambda_function.connect_genesys)[*].arn
}

output "aws_lambda_function_invoke_arn" {
  value = values(aws_lambda_function.connect_genesys)[*].invoke_arn
}