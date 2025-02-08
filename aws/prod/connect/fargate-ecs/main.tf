module "fargate_ecs" {
  source = "./modules/fargate_ecs"
}

module "cognito_db" {
  source = "./modules/cognito_db"
}

module "bitbucket_user" {
  source = "./modules/bitbucket_user"

  ecr_arn = module.fargate_ecs.ecr_arn
}

output "ecr_arn" {
  value = module.fargate_ecs.ecr_arn
}

output "task_role" {
  value = module.fargate_ecs.task_role
}

output "execution_role" {
  value = module.fargate_ecs.execution_role
}

output "ecs_task_definition_arn" {
  value = module.fargate_ecs.ecs_task_definition_arn
}

output "ecs_task_definition_family" {
  value = module.fargate_ecs.ecs_task_definition_family
}

output "ecs_task_definition_revision" {
  value = module.fargate_ecs.ecs_task_definition_revision
}

output "load_balancer_arn" {
  value = module.fargate_ecs.load_balancer_arn
}

output "load_balancer_dns_name" {
  value = module.fargate_ecs.load_balancer_dns_name
}

output "load_balancer_url" {
  value = module.fargate_ecs.load_balancer_url
}

output "elastic_container_service_name" {
  value = module.fargate_ecs.elastic_container_service_name
}

output "aws_security_group_my_fargate_service_lb_security_group6_fbf16_f1_id" {
  value = module.fargate_ecs.aws_security_group_my_fargate_service_lb_security_group6_fbf16_f1_id
}

output "aws_security_group_fargate_service_lb_security_group_id" {
  value = module.fargate_ecs.aws_security_group_fargate_service_lb_security_group_id
}

output "aws_security_group_my_fargate_service_security_group7016792_a_id" {
  value = module.fargate_ecs.aws_security_group_my_fargate_service_security_group7016792_a_id
}

output "aws_security_group_fargate_service_security_group_id" {
  value = module.fargate_ecs.aws_security_group_fargate_service_security_group_id
}

output "s3_bucket_url" {
  value = module.cognito_db.s3_bucket_url
}

output "connect_table" {
  value = module.cognito_db.connect_table
}

output "db_arn" {
  value = module.cognito_db.db_arn
}

output "user_pool_id" {
  value = module.cognito_db.user_pool_id
}

output "cognito_client_secret" {
  value = module.cognito_db.cognito_client_secret
  sensitive = true
}

output "cognito_client_id" {
  value = module.cognito_db.cognito_client_id
}

output "aws_iam_user_arn" {
  value = module.bitbucket_user.aws_iam_user_arn
}