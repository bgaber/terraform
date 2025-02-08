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
  name               = "digital_assistant_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_layer_version" "langchain_agent_layer" {
  s3_bucket  = var.s3_bucket
  s3_key     = var.lambda_layer_deployment_pkg1
  layer_name = "cc-langchain-agent-layer"

  compatible_runtimes = ["python3.10"]
}

resource "aws_lambda_layer_version" "twilio_python_layer" {
  s3_bucket  = var.s3_bucket
  s3_key     = var.lambda_layer_deployment_pkg2
  layer_name = "twilio_python_layer"

  compatible_runtimes = ["python3.10"]
}

resource "aws_lambda_function" "digital_assistant" {
  description   = var.lambda_function_description
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  layers        = [aws_lambda_layer_version.langchain_agent_layer.arn, aws_lambda_layer_version.twilio_python_layer.arn]

  s3_bucket     = var.s3_bucket
  s3_key        = var.lambda_deployment_pkg

  runtime       = "python3.10"
  timeout       = var.lambda_timeout_value

  environment {
    variables = {
      AZURETOKEN                        = "https://systrackcegl.b2clogin.com/systrackcegl.onmicrosoft.com/b2c_1_ropc_auth/oauth2/v2.0/token"
      AZURE_OPENAI_API_KEY              = ""
      AZURE_OPENAI_ENDPOINT             = "https://ccdev-azure-openai.openai.azure.com/"
      CC_PSWD                           = ""
      CC_URL                            = "compucom.lakesidesoftware.com"
      CC_USER                           = ""
      CLIENTID                          = ""
      DASHGUID                          = ""
      DASHNAME                          = "cc-systrack-chat-device-info"
      DATAOBNAME                        = "DeviceStats"
      FLEX_WORKSPACE_SID                = ""
      INBOUND_CHAT_MESSAGE_HANDLER_PATH = "https://bedrock-integration-3721.twil.io/inboundChatMessageHandler"
      MULE_API_URL                      = "https://muleqc.diam.compucom.com"
      MULE_PASSWORD                     = ""
      MULE_TRACK_PASS                   = ""
      MULE_TRACK_USER                   = ""
      MULE_USERNAME                     = ""
      OPENAI_API_KEY                    = ""
      OPENAI_API_VERSION                = "2023-12-01-preview"
      OPENAI_MODEL                      = "gpt-4o"
      SCOPE                             = ""
      TWILIO_ACCOUNT_SID                = ""
      TWILIO_AUTH_TOKEN                 = ""
      TWILIO_FLEX_CHAT_SERVICE_SID      = ""
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs_policy,
    aws_cloudwatch_log_group.digital_assistant,
  ]
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "digital_assistant" {
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
  name        = "digital_assistant_lambda_logging"
  path        = "/"
  description = "IAM policy for logging from digital assistant lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "bedrock_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

output "aws_lambda_function_arn" {
  value = aws_lambda_function.digital_assistant.arn
}

output "aws_lambda_function_invoke_arn" {
  value = aws_lambda_function.digital_assistant.invoke_arn
}