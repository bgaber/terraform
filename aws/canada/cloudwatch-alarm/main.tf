resource "aws_cloudwatch_metric_alarm" "rds_disk_free_space" {
  alarm_name                = var.alarm_name
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  period                    = 60
  statistic                 = "Minimum"
  threshold                 = 16106127360
  alarm_description         = "This metric monitors RDS disk free space"
  insufficient_data_actions = []
  alarm_actions             = [var.sns_topic_arn]
  dimensions = {
    DBInstanceIdentifier  = var.rds_db_name
  }
}

output "aws_cloudwatch_metric_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.rds_disk_free_space.arn
}

output "aws_cloudwatch_metric_alarm_id" {
  value = aws_cloudwatch_metric_alarm.rds_disk_free_space.id
}