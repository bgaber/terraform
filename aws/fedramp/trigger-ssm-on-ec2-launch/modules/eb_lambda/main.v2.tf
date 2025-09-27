data "aws_caller_identity" "current" {}
locals {
    account_id = data.aws_caller_identity.current.account_id
    ssm_region = terraform.workspace == "default" ? "us-east-1" : "us-west-2"
    create_iam_resources = terraform.workspace == "default"
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_role" {
  count = local.create_iam_resources ? 1 : 0
  name  = var.lambda_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for SSM Access
resource "aws_iam_policy" "ssm_policy" {
  count       = local.create_iam_resources ? 1 : 0
  name        = var.ssm_policy
  description = "Grants Lambda access to SSM and EC2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:ListCommandInvocations",
          "ssm:GetCommandInvocation",
          "ssm:DescribeInstanceInformation"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:CreateTags"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "attach_ssm_policy" {
  count      = local.create_iam_resources ? 1 : 0
  role       = aws_iam_role.lambda_role[0].name
  policy_arn = aws_iam_policy.ssm_policy[0].arn
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
# IAM Policy for Lambda Logging
resource "aws_iam_policy" "lambda_logging" {
  count       = local.create_iam_resources ? 1 : 0
  name        = "lambda-logging-${var.lambda_logging_policy_name}"
  path        = "/"
  description = "Allows Lambda to write logs to CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement: [
        {
            Sid: "CreateLogGroup",
            Effect: "Allow",
            Action: "logs:CreateLogGroup",
            Resource: [
              "arn:aws:logs:${local.ssm_region}:${local.account_id}:*",
            ]
        },
        {
            Sid: "CloudWatchLambda",
            Effect: "Allow",
            Action: [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            Resource: [
              "arn:aws:logs:${local.ssm_region}:${local.account_id}:log-group:/aws/lambda/${var.lambda_name}:*",
            ]
        },
        {
            Sid: "ParameterStoreAccess",
            Effect: "Allow",
            Action: [
                "ssm:GetParameter",
                "ssm:PutParameter"
            ],
            Resource: [
              "arn:aws:ssm:${local.ssm_region}:${local.account_id}:parameter/*",
            ]
        }
    ]
  })
}

# Attach Logging Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "attach_logging" {
  count      = local.create_iam_resources ? 1 : 0
  role       = aws_iam_role.lambda_role[0].name
  policy_arn = aws_iam_policy.lambda_logging[0].arn
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

data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "${path.module}/code/ssm_trigger_lambda_function.py" 
  output_path = "${path.module}/artifacts/${var.lambda_archive}"
}

data "aws_ssm_parameter" "falcon_client_id" {
  name = "/crowdstrike/FALCON_CLIENT_ID"
}

data "aws_ssm_parameter" "falcon_client_secret" {
  name = "/crowdstrike/FALCON_CLIENT_SECRET"
}

# Lambda Function for Querying Athena
resource "aws_lambda_function" "ssm_trigger_lambda" {
  function_name = var.lambda_name
  role          = local.create_iam_resources ? aws_iam_role.lambda_role[0].arn : "arn:aws:iam::${local.account_id}:role/${var.lambda_role}"
  handler       = "ssm_trigger_lambda_function.lambda_handler"

  filename = "${data.archive_file.python_lambda_package.output_path}"
  source_code_hash = "${data.archive_file.python_lambda_package.output_base64sha256}"

  memory_size = 512
  runtime = "python3.12"
  timeout = 600

  environment {
    variables = {
      FALCON_CLIENT_ID          = data.aws_ssm_parameter.falcon_client_id.value
      FALCON_CLIENT_SECRET      = data.aws_ssm_parameter.falcon_client_secret.value
      LINUX_SSM_DOCUMENT_NAME   = var.linux_ssm_document_name
      WINDOWS_SSM_DOCUMENT_NAME = var.windows_ssm_document_name
    }
  }
  
# https://spacelift.io/blog/terraform-ignore-changes
  lifecycle {
    ignore_changes = [
      environment,
    ]
  }
}

resource "aws_cloudwatch_event_rule" "ec2_launch_rule" {
  name        = "TriggerSSMOnEC2Launch"
  description = "Triggers SSM Run Command when an EC2 instance is launched"

  event_pattern = jsonencode({
    "source": ["aws.ec2"],
    "detail-type": ["AWS API Call via CloudTrail"],
    "detail": {
      "eventSource": ["ec2.amazonaws.com"],
      "eventName": ["RunInstances"]
    }
  })
}

# EventBridge Target (Lambda)
resource "aws_cloudwatch_event_target" "ec2_launch_target" {
  rule      = aws_cloudwatch_event_rule.ec2_launch_rule.name
  target_id = "LambdaTarget"
  arn       = aws_lambda_function.ssm_trigger_lambda.arn
}

# Lambda Permission to allow EventBridge invocation
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ssm_trigger_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_launch_rule.arn
}

output "aws_lambda_function_arn" {
  value = aws_lambda_function.ssm_trigger_lambda.arn
}

output "aws_lambda_function_invoke_arn" {
  value = aws_lambda_function.ssm_trigger_lambda.invoke_arn
}