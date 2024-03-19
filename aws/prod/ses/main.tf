resource "aws_sns_topic" "ses_events" {
  for_each = toset(var.ses_events)
  name     = join("-", ["sns-email", each.value])
}

resource "aws_ses_configuration_set" "prod" {
  name = var.configuration_set_name
}

resource "aws_ses_event_destination" "sns" {
  for_each               = toset(var.ses_events)
  name                   = "ses-${each.value}-event-destination-sns"
  configuration_set_name = aws_ses_configuration_set.prod.name
  enabled                = true
  matching_types         = [each.value]

  sns_destination {
    topic_arn = aws_sns_topic.ses_events[each.value].arn
  }
}

output "aws_ses_configuration_set_arn" {
  value = aws_ses_configuration_set.prod.arn
}

output "aws_ses_event_destination_arn" {
  value = values(aws_ses_event_destination.sns)[*].arn
}