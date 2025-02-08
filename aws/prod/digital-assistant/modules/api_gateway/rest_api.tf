resource "aws_api_gateway_account" "digital_assistant" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudwatch" {
  name               = "digital_assistant_api_gw_cloudwatch_global"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = ["*"]
  }
}
resource "aws_iam_role_policy" "cloudwatch" {
  name   = "default"
  role   = aws_iam_role.cloudwatch.id
  policy = data.aws_iam_policy_document.cloudwatch.json
}

resource "aws_api_gateway_rest_api" "rest_api"{
  name        = var.rest_api_name
  description = var.rest_api_description
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Add Trigger to Lambda function
# Give API Gateway permission to access the Lambda function.
resource "aws_lambda_permission" "allow_api" {
  statement_id  = "AllowApiGatewayInvocation"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*"
}

resource "aws_api_gateway_resource" "rest_api_resource" {
  for_each = toset(var.api_gw_resources)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = each.value
}

resource "aws_api_gateway_method" "rest_api_post_method"{
  for_each = toset(var.api_gw_resources)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource[each.value].id
  http_method = "POST"
  authorization = "NONE"
  request_parameters = {"method.request.header.InvocationType" = false}
}

resource "aws_api_gateway_integration" "rest_api_post_method_integration" {
  for_each = toset(var.api_gw_resources)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource[each.value].id
  http_method = aws_api_gateway_method.rest_api_post_method[each.value].http_method
  integration_http_method = "POST"
  request_parameters = { "integration.request.header.X-Amz-Invocation-Type" = "method.request.header.InvocationType" }
  type                    = "AWS"
  uri                     = var.lambda_invoke_arn
  request_templates = {
    "application/json" = <<EOF
{
  "method": "$context.httpMethod",
  "body" : $input.json('$'),
  "headers": {
    #foreach($param in $input.params().header.keySet())
    "$param": "$util.escapeJavaScript($input.params().header.get($param))"
    #if($foreach.hasNext),#end
    #end
  }
}
EOF
  }
}

resource "aws_api_gateway_method_response" "rest_api_post_method_response_200"{
  for_each = toset(var.api_gw_resources)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource[each.value].id
  http_method = aws_api_gateway_method.rest_api_post_method[each.value].http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "rest_api_post_method_integration_response_200" {
  for_each = toset(var.api_gw_resources)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource[each.value].id
  http_method = aws_api_gateway_integration.rest_api_post_method_integration[each.value].http_method
  status_code = aws_api_gateway_method_response.rest_api_post_method_response_200[each.value].status_code
}

resource "aws_api_gateway_deployment" "rest_api_deployment" {
  # depends_on = [
  #   aws_api_gateway_method.rest_api_post_method,
  #   aws_api_gateway_integration.rest_api_post_method_integration
  # ]

  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_stage" "prod_stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "prod"
}

# Global stage settings
resource "aws_api_gateway_method_settings" "prod" {
  depends_on = [
    aws_api_gateway_account.digital_assistant
  ]

  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.prod_stage.stage_name
  method_path = "*/*"
  settings {
    logging_level   = "ERROR"
    throttling_rate_limit = 10000
    throttling_burst_limit = 5000
  }
}

resource "aws_api_gateway_method_settings" "prod_stage" {
  depends_on = [
    aws_api_gateway_account.digital_assistant
  ]

  for_each = toset(var.api_gw_resources)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.prod_stage.stage_name
  method_path = "${each.value}/POST"
  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    throttling_rate_limit = 10000
    throttling_burst_limit = 5000
  }
}