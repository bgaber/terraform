resource "aws_sns_topic" "noc_notification" {
  name = var.sns_topic
}

resource "aws_sns_topic_subscription" "email_notification_target" {
  topic_arn = aws_sns_topic.noc_notification.arn
  protocol  = "email"
  endpoint  = "brian.gaber@tecsys.com"
}

output "sns_topic_arn" {
  value = aws_sns_topic.noc_notification.arn
}

output "sns_subscription_arn" {
  value = aws_sns_topic_subscription.email_notification_target.arn
}