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

# Use the Prod Role
data "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
}

resource "aws_lambda_layer_version" "lambda_layer" {
  s3_bucket  = var.s3_bucket
  s3_key     = var.lambda_layer_deployment_pkg
  layer_name = "twilio-layer"

  compatible_runtimes = ["nodejs18.x"]
}

resource "aws_lambda_function" "connect" {
  description   = var.lambda_function_description
  function_name = var.lambda_function_name
  role          = data.aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  layers        = [aws_lambda_layer_version.lambda_layer.arn]

  s3_bucket     = var.s3_bucket
  s3_key        = var.lambda_deployment_pkg

  runtime       = "nodejs18.x"
  timeout       = var.lambda_timeout_value

  environment {
    variables = {
      FLEX_WORKSPACE_SID                = ""
      INBOUND_CHAT_MESSAGE_HANDLER_PATH = "https://lex-integration-4143.twil.io/inboundChatMessageHandler"
      TWILIO_ACCOUNT_SID                = ""
      TWILIO_AUTH_TOKEN                 = ""
      TWILIO_FLEX_CHAT_SERVICE_SID      = ""
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.connect
  ]
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "connect" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

output "aws_lambda_function_arn" {
  value = aws_lambda_function.connect.arn
}

output "aws_lambda_function_invoke_arn" {
  value = aws_lambda_function.connect.invoke_arn
}