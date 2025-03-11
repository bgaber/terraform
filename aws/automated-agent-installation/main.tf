module "sns" {
  source = "./modules/sns"
}

module "eb_lambda" {
  sns_topic_arn = module.sns.sns_topic_arn
  source = "./modules/eb_lambda"
}

output "lambda_function_arn" {
  value = module.eb_lambda.aws_lambda_function_arn
}

output "lambda_function_invoke_arn" {
  value = module.eb_lambda.aws_lambda_function_invoke_arn
}

output "sns_topic_arn" {
  value = module.sns.sns_topic_arn
}

output "sns_subsctiption_arn" {
  value = module.sns.sns_subscription_arn
}

output "scheduler_schedule_id" {
  value = module.eb_lambda.aws_scheduler_schedule_id
}

output "scheduler_schedule_arn" {
  value = module.eb_lambda.aws_scheduler_schedule_arn
}