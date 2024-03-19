module "fargate_ecs" {
  source = "./modules/fargate_ecs"
}

module "cognito_db" {
  source = "./modules/cognito_db"
}
# module "bitbucket_user" {
#   source = "./modules/bitbucket_user"

#   ecr_arn = module.fargate_ecs.ecr_arn
# }