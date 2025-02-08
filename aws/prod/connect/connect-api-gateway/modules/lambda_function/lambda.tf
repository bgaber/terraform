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
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
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
  role          = aws_iam_role.iam_for_lambda.arn
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
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.connect,
  ]
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "connect" {
  name              = "/aws/lambda/${var.lambda_function_name}"
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
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}


# data "aws_iam_policy_document" "lex_policy_doc" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "iam:GetRole",
#       "iam:CreateServiceLinkedRole",
#       "iam:DeleteServiceLinkedRole",
#       "iam:GetServiceLinkedRoleDeletionStatus",
#       "iam:PassRole",
#     ]

#     resources = ["arn:aws:iam::*:role/aws-service-role/lexv2.amazonaws.com/AWSServiceRoleForLexV2Bots*"]
#   }
# }

# resource "aws_iam_policy" "lex_policy" {
#   name        = "lex_policy"
#   path        = "/"
#   description = "IAM policy for Lex"
#   policy      = data.aws_iam_policy_document.lex_policy_doc.json
# }

resource "aws_iam_role_policy_attachment" "lex_policy_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonLexFullAccess"
}

output "aws_lambda_function_arn" {
  value = aws_lambda_function.connect.arn
}

output "aws_lambda_function_invoke_arn" {
  value = aws_lambda_function.connect.invoke_arn
}