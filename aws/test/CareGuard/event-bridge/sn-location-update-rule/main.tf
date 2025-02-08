data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
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
            "arn:aws:lambda:us-east-1:${local.account_id}:function:careguard-sn-location-update:*",
            "arn:aws:lambda:us-east-1:${local.account_id}:function:careguard-sn-location-update"
        ]
      }
    ]
  })
}

resource "aws_scheduler_schedule" "careguard" {
  name        = var.schedule_name
  description = var.schedule_description
  group_name  = "default"
  start_date  = "2024-06-18T01:00:00Z"
  schedule_expression_timezone = "America/New_York"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(*/5 * * * ? *)" # run every 5 minutes

  target {
    arn      = var.lambda_arn
    # role that allows scheduler to start the task
    role_arn = aws_iam_role.scheduler.arn
  }
}

output "aws_scheduler_schedule_id" {
  value = aws_scheduler_schedule.careguard.id
}

output "aws_scheduler_schedule_arn" {
  value = aws_scheduler_schedule.careguard.arn
}