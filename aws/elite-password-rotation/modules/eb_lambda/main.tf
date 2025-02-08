data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
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
  name               = "role_for_lambda_${var.lambda_function_name}"
  assume_role_policy = data.aws_iam_policy_document.trusted_entity.json
}

resource "aws_lambda_function" "password_rotation" {
  description   = var.lambda_function_description
  function_name = var.lambda_function_name
  role          = aws_iam_role.role_for_lambda.arn
  handler       = "password_rotation_lambda.lambda_handler"

  s3_bucket = var.s3_bucket_name
  s3_key    = var.lambda_deployment_pkg

  memory_size = 512
  runtime = "python3.12"
  timeout = 60

  environment {
    variables = {
      DATADOG_API_KEY                       = ""
      DATADOG_APP_KEY                       = ""
      POST_K8S_CURRENT_PASSWD_GLOBAL_VAR_ID = "0a29f09b-b815-442e-b9b3-64b900f3f7df"
      POST_K8S_NEW_PASSWD_GLOBAL_VAR_ID     = "546911d3-a82e-4fa9-a7c5-bee8668a7f54"
      KEYCLOAK_ADMIN_PASSWORD_VAR_ID        = ""
    }
  }

  # https://spacelift.io/blog/terraform-ignore-changes
  lifecycle {
    ignore_changes = [
      environment,
    ]
  }
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "password_rotation" {
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

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_basic_execution_role" {
  name        = "lambda-logging-${var.lambda_function_name}"
  path        = "/"
  description = "IAM policy for logging from ${var.lambda_function_name}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement: [
        {
            Sid: "CreateLogGroup",
            Effect: "Allow",
            Action: "logs:CreateLogGroup",
            Resource: [
              "arn:aws:logs:us-east-1:${local.account_id}:*",
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
              "arn:aws:logs:us-east-1:${local.account_id}:log-group:/aws/lambda/${var.lambda_function_name}:*",
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
              "arn:aws:ssm:us-east-1:${local.account_id}:parameter/*",
            ]
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_role" {
  role       = aws_iam_role.role_for_lambda.name
  policy_arn = aws_iam_policy.lambda_basic_execution_role.arn
}

resource "aws_iam_role" "scheduler" {
  name = "${var.schedule_name}-scheduler-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["scheduler.amazonaws.com"]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "scheduler" {
  policy_arn = aws_iam_policy.scheduler.arn
  role       = aws_iam_role.scheduler.name
}

resource "aws_iam_policy" "scheduler" {
  name = "${var.schedule_name}-scheduler-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # allow scheduler to execute the task
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = [
            "arn:aws:lambda:us-east-1:${local.account_id}:function:${var.lambda_function_name}:*",
            aws_lambda_function.password_rotation.arn
        ]
      }
    ]
  })
}

resource "aws_scheduler_schedule" "password_rotation" {
  name        = var.schedule_name
  description = var.schedule_description
  group_name  = "default"
  #start_date  = "2024-11-20T13:00:00Z"
  schedule_expression_timezone = "America/New_York"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(0 0 20 * ? *)" # run at midnight on the 20th day of the month

  target {
    arn      = aws_lambda_function.password_rotation.arn
    # role that allows scheduler to start the task
    role_arn = aws_iam_role.scheduler.arn
  }
}

output "aws_lambda_function_arn" {
  value = aws_lambda_function.password_rotation.arn
}

output "aws_lambda_function_invoke_arn" {
  value = aws_lambda_function.password_rotation.invoke_arn
}

output "aws_scheduler_schedule_id" {
  value = aws_scheduler_schedule.password_rotation.id
}

output "aws_scheduler_schedule_arn" {
  value = aws_scheduler_schedule.password_rotation.arn
}