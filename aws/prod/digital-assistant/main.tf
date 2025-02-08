module "bitbucket_user" {
  source = "./modules/bitbucket_user"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "api_gw_lambda_function" {
  source = "./modules/api_gw_lambda_function"
}

module "api_gateway" {
  source = "./modules/api_gateway"

  lambda_invoke_arn = module.api_gw_lambda_function.aws_lambda_function_invoke_arn
}

# module "bedrock" {
#   source = "./modules/bedrock"
# }

# module "open_search" {
#   source = "./modules/open_search"
# }

output "bitbucket_user_arn" {
  value = module.bitbucket_user.bitbucket_user_arn
}

output "digital_assistant_table" {
  value = module.dynamodb.digital_assistant_table
}

output "db_arn" {
  value = module.dynamodb.db_arn
}

output "lambda_function_arn" {
  value = module.api_gw_lambda_function.aws_lambda_function_arn
}

output "lambda_function_invoke_arn" {
  value = module.api_gw_lambda_function.aws_lambda_function_invoke_arn
}