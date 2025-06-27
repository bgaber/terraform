data "aws_ssm_parameter" "falcon_hec_api_key" {
  name = "/crowdstrike/FALCON_HEC_API_KEY_WAF"
}

data "aws_ssm_parameter" "falcon_hec_api_url" {
  name = "/crowdstrike/FALCON_HEC_API_URL_WAF"
}

resource "aws_cloudwatch_event_connection" "connection" {
  name               = "${var.event_bridge_name}-connection"
  description        = "Falcon HEC connection for AWS WAF"
  authorization_type = "API_KEY"
  auth_parameters {
  api_key {
    key   = "Authorization"
    value = "Bearer ${data.aws_ssm_parameter.falcon_hec_api_key.value}"
    }
  }
}

resource "aws_cloudwatch_event_api_destination" "destination" {
  name                             = "${var.event_bridge_name}-api"
  description                      = "Falcon HEC connector endpoint for AWS WAF"
  connection_arn                   = aws_cloudwatch_event_connection.connection.arn
  invocation_endpoint              = "${data.aws_ssm_parameter.falcon_hec_api_url.value}/raw"
  http_method                      = "POST"
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name           = "${var.event_bridge_name}-rule"
  description    = "HEC connector for AWS WAF"
  event_pattern  = jsonencode({ "source": ["aws.wafv2"] })
}

resource "aws_iam_role" "event_bridge_iam_role" {
  name               = "${var.event_bridge_name}_EventBridgeRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]


    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "event_bridge_iam_policy" {
  name   = "${var.event_bridge_name}_EventBridge_Invoke_Api_Destination"
  policy = data.aws_iam_policy_document.assume_eventbridge_role.json
}

data "aws_iam_policy_document" "assume_eventbridge_role" {
  statement {
    effect  = "Allow"
    actions = ["events:InvokeApiDestination"]


    resources = [aws_cloudwatch_event_api_destination.destination.arn]
  }
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  policy_arn = aws_iam_policy.event_bridge_iam_policy.arn
  role       = aws_iam_role.event_bridge_iam_role.name
}

resource "aws_cloudwatch_event_target" "event_target" {
  arn            = aws_cloudwatch_event_api_destination.destination.arn
  rule           = aws_cloudwatch_event_rule.event_rule.name
  role_arn       = aws_iam_role.event_bridge_iam_role.arn
}

output "event_connection_arn" {
 value = aws_cloudwatch_event_connection.connection.arn
}

output "event_api_destination_arn" {
 value = aws_cloudwatch_event_api_destination.destination.arn
}

output "event_bridge_rule_arn" {
 value = aws_cloudwatch_event_rule.event_rule.arn
}

output "event_bridge_rule_iam_role_arn" {
 value = aws_iam_role.event_bridge_iam_role.arn
}