data "aws_caller_identity" "prod" {}

locals {
    account_id = data.aws_caller_identity.prod.account_id
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  for_each           = var.lex_bot_names
  name               = join ("_", ["iam_for_lambda", each.key])
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "bot_router" {
  for_each      = var.lex_bot_names
  description   = join(" ", [each.key, "router function"])
  function_name = join("-", [each.key, "router"])
  role          = aws_iam_role.iam_for_lambda[each.key].arn
  handler       = "lambda_function.lambda_handler"

  s3_bucket = var.s3_bucket
  s3_key    = var.lambda_deployment_pkg

  runtime = "python3.9"

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.ai-selfhelp-router-lambda,
  ]
}

# As of Sep 2023 Terraform does not support Lexv2 which is what we use
# https://github.com/hashicorp/terraform-provider-aws/issues/21375
# data "aws_lex_bot" "lex_bots" {
#   for_each = var.lex_bot_names
#   name     = each.value
# }

resource "aws_lambda_permission" "allow_lex" {
  for_each      = var.lex_bot_names
  statement_id  = "lex-lambda-invokeFunction-TSTALIASID"
  action        = "lambda:InvokeFunction"
  function_name = join("-", [each.key, "router"])
  principal     = "lexv2.amazonaws.com"
  source_arn    = var.lex_bot_alias_arn
  # source_arn    = data.aws_lex_bot.lex_bots[each.value].arn
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "ai-selfhelp-router-lambda" {
  for_each          = var.lex_bot_names
  name              = "/aws/lambda/${each.key}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  for_each    = var.lex_bot_names
  name        = join ("_", ["lambda_logging", each.key])
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement: [
        {
            Sid: "CloudWatchLambda",
            Effect: "Allow",
            Action: [
                "logs:CreateLogStream",
                "lambda:InvokeFunction",
                "logs:PutLogEvents"
            ],
            Resource: [
              "arn:aws:logs:us-east-1:${local.account_id}:log-group:/aws/lambda/${each.key}-router:*",
              "arn:aws:logs:us-west-2:${local.account_id}:log-group:/aws/lambda/${each.key}-router:*"
            ]
        },
        {
            Sid: "CreateLogGroup",
            Effect: "Allow",
            Action: "logs:CreateLogGroup",
            Resource: [
              "arn:aws:logs:us-east-1:${local.account_id}:*",
              "arn:aws:logs:us-west-2:${local.account_id}:*"
            ]
        },
        {
            Sid: "KendraTicketInvokeFunction",
            Effect: "Allow",
            Action: "lambda:InvokeFunction",
            Resource: [
                "arn:aws:lambda:us-east-1:${local.account_id}:function:kendra_Search",
                "arn:aws:lambda:us-west-2:${local.account_id}:function:kendra_Search"
            ]
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  for_each   = var.lex_bot_names
  role       = aws_iam_role.iam_for_lambda[each.key].name
  policy_arn = aws_iam_policy.lambda_logging[each.key].arn
}

output "aws_lambda_function_arn" {
  value = values(aws_lambda_function.bot_router)[*].arn
}

output "aws_lambda_function_invoke_arn" {
  value = values(aws_lambda_function.bot_router)[*].invoke_arn
}