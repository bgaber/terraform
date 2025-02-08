module "genesys_container_user" {
  source = "./modules/genesys_container_user"
}

module "connect_genesys_ecr" {
  source = "./modules/ecr"
}

module "connect_genesys_ecs" {
  source = "./modules/fargate_ecs"

  ecr_arn = module.connect_genesys_ecr.ecr_arn
}

module "bitbucket_user" {
  source = "./modules/bitbucket_user"

  ecr_arn            = module.connect_genesys_ecr.ecr_arn
  task_role_arn      = module.connect_genesys_ecs.task_role_arn
  execution_role_arn = module.connect_genesys_ecs.execution_role_arn
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "lambda_functions" {
  source = "./modules/lambda_functions"
}

module "api_gateway" {
  source = "./modules/api_gateway"

  lambda_arn        = "arn:aws:lambda:us-east-1:122639376858:function:genesys-post-utterance"
  lambda_invoke_arn = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:122639376858:function:genesys-post-utterance/invocations"
}

module "connect_genesys_route53" {
  source = "./modules/route53"

  providers = {
    aws = aws.route53
  }

  prod_record_value = module.connect_genesys_ecs.load_balancer_dns_name
}
