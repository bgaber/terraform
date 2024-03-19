# Use the Prod Role
data "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_kendra_search_lambda"
}

resource "aws_lambda_function" "connect" {
  description   = var.lambda_function_description
  function_name = var.lambda_function_name
  role          = data.aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  s3_bucket = var.s3_bucket
  s3_key    = var.lambda_deployment_pkg

  runtime = "python3.9"

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