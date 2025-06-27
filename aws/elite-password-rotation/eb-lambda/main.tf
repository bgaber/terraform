module "iam_service_account" {
  source = "./modules/iam_service_account"
  s3_bucket_name        = var.s3_bucket_name
  lambda_function_name  = var.lambda_function_name
  lambda_deployment_pkg = var.lambda_deployment_pkg
}

module "eb_lambda" {
  source = "./modules/eb_lambda"
  s3_bucket_name        = var.s3_bucket_name
  lambda_function_name  = var.lambda_function_name
  lambda_deployment_pkg = var.lambda_deployment_pkg
}

output "service_account_id" {
  value = module.iam_service_account.service_account_id
}

output "service_account_arn" {
  value = module.iam_service_account.service_account_arn
}

output "service_account_name" {
  value = module.iam_service_account.service_account_name
}

output "service_secret_id" {
  value = module.iam_service_account.service_secret_id
}

output "service_secret_access_key" {
  value = module.iam_service_account.service_secret_access_key
  sensitive = true
}

output "lambda_function_arn" {
  value = module.eb_lambda.aws_lambda_function_arn
}

output "lambda_function_invoke_arn" {
  value = module.eb_lambda.aws_lambda_function_invoke_arn
}

output "scheduler_schedule_id" {
  value = module.eb_lambda.aws_scheduler_schedule_id
}

output "scheduler_schedule_arn" {
  value = module.eb_lambda.aws_scheduler_schedule_arn
}