output "ecs_task_role_arn" {
  value = module.connect_genesys_ecs.task_role_arn
}

output "ecs_execution_role_arn" {
  value = module.connect_genesys_ecs.execution_role_arn
}

output "ecs_task_definition_arn" {
  value = module.connect_genesys_ecs.ecs_task_definition_arn
}

output "ecs_task_definition_family" {
  value = module.connect_genesys_ecs.ecs_task_definition_family
}

output "ecs_task_definition_revision" {
  value = module.connect_genesys_ecs.ecs_task_definition_revision
}

output "load_balancer_arn" {
  value = module.connect_genesys_ecs.load_balancer_arn
}

output "load_balancer_dns_name" {
  value = module.connect_genesys_ecs.load_balancer_dns_name
}

output "load_balancer_url" {
  value = module.connect_genesys_ecs.load_balancer_url
}

output "elastic_container_service_name" {
  value = module.connect_genesys_ecs.elastic_container_service_name
}

output "load_balancer_security_group_id" {
  value = module.connect_genesys_ecs.aws_security_group_lb_security_group_id
}

output "ecs_service_security_group_id" {
  value = module.connect_genesys_ecs.aws_security_group_ecs_service_security_group_id
}

output "ecr_arn" {
  value = module.connect_genesys_ecr.ecr_arn
}

output "genesys_container_user_arn" {
  value = module.genesys_container_user.genesys_container_user_arn
}

output "bitbucket_user_arn" {
  value = module.bitbucket_user.bitbucket_user_arn
}

output "connect_genesys_dynamodb_table" {
  value = module.dynamodb.connect_genesys_table
}

output "dynamodb_arn" {
  value = module.dynamodb.db_arn
}

output "lambda_function_arn" {
  value = module.lambda_functions.aws_lambda_function_arn
}

output "lambda_function_invoke_arn" {
  value = module.lambda_functions.aws_lambda_function_invoke_arn
}

output "rest_api_arn" {
  value = module.api_gateway.rest_api_arn
}

output "rest_api_execution_arn" {
  value = module.api_gateway.rest_api_execution_arn
}

output "rest_api_id" {
  value = module.api_gateway.rest_api_id
}

output "rest_api_root_resource_id" {
  value = module.api_gateway.rest_api_root_resource_id
}

output "route53_record_name" {
  value = module.connect_genesys_route53.connect_genesys_prod_route53_record_name
}

output "route53_record_fqdn" {
  value = module.connect_genesys_route53.connect_genesys_prod_route53_record_fqdn
}