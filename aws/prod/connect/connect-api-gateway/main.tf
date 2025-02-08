module "lambda_function" {
  source = "./modules/lambda_function"
}
module "api_gateway" {
  source = "./modules/api_gateway"

  lambda_invoke_arn = module.lambda_function.aws_lambda_function_invoke_arn
}