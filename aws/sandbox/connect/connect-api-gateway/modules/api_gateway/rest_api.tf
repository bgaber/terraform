resource "aws_api_gateway_rest_api" "rest_api"{
  name        = var.rest_api_name
  description = var.rest_api_description
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "rest_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "sendmessage"
}

resource "aws_api_gateway_method" "rest_api_post_method"{
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = "POST"
  authorization = "NONE"
  request_parameters = {"method.request.header.InvocationType" = false}
}

resource "aws_api_gateway_integration" "rest_api_post_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_method.rest_api_post_method.http_method
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
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_method.rest_api_post_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "rest_api_post_method_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_integration.rest_api_post_method_integration.http_method
  status_code = aws_api_gateway_method_response.rest_api_post_method_response_200.status_code
}

resource "aws_api_gateway_deployment" "rest_api_deployment" {
  depends_on = [
    aws_api_gateway_method.rest_api_post_method,
    aws_api_gateway_integration.rest_api_post_method_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.rest_api_resource.id,
      aws_api_gateway_method.rest_api_post_method.id,
      aws_api_gateway_integration.rest_api_post_method_integration.id
    ]))
  }
}

resource "aws_api_gateway_stage" "dev_stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "dev"
}

resource "aws_api_gateway_stage" "v1_stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "v1"
}

# Global stage settings
resource "aws_api_gateway_method_settings" "v1" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.v1_stage.stage_name
  method_path = "*/*"
  settings {
    logging_level   = "ERROR"
    throttling_rate_limit = 10000
    throttling_burst_limit = 5000
  }
}

resource "aws_api_gateway_method_settings" "v1_sendmessage" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.v1_stage.stage_name
  method_path = "sendmessage/POST"
  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    throttling_rate_limit = 10000
    throttling_burst_limit = 5000
  }
}