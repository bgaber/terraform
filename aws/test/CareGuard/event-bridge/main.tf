data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_iam_role" "scheduler" {
  for_each = {for i, v in var.eb_sched_attributes:  i => v}
    name = "${each.value.sched_name}-scheduler-role"

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
  depends_on = [aws_iam_role.scheduler]

  for_each = {for i, v in var.eb_sched_attributes:  i => v}
    policy_arn = "arn:aws:iam::${local.account_id}:policy/${each.value.sched_name}-scheduler-policy"
    role       = "${each.value.sched_name}-scheduler-role"
}

resource "aws_iam_policy" "scheduler" {
  for_each = {for i, v in var.eb_sched_attributes:  i => v}
    name = "${each.value.sched_name}-scheduler-policy"

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
            "${each.value.lambda_arn}:*",
            "${each.value.lambda_arn}"
        ]
      }
    ]
  })
}

resource "aws_scheduler_schedule" "careguard" {
  for_each = {for i, v in var.eb_sched_attributes:  i => v}
    name        = each.value.sched_name
    description = each.value.sched_description

  group_name  = "default"
  start_date  = "2024-06-19T04:00:00Z"
  schedule_expression_timezone = "America/New_York"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(*/5 * * * ? *)" # run every 5 minutes

  target {
    arn      = each.value.lambda_arn
    # role that allows scheduler to start the task
    role_arn = "arn:aws:iam::${local.account_id}:role/${each.value.sched_name}-scheduler-role"
  }
}

output "aws_iam_role_schedule_arn" {
  value = values(aws_iam_role.scheduler)[*].arn
}

output "aws_iam_policy_schedule_arn" {
  value = values(aws_iam_policy.scheduler)[*].arn
}

output "aws_scheduler_schedule_id" {
  value = values(aws_scheduler_schedule.careguard)[*].id
}

output "aws_scheduler_schedule_arn" {
  value = values(aws_scheduler_schedule.careguard)[*].arn
}