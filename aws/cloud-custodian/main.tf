module "sqs" {
  source = "./modules/sqs"

  providers = {
    aws = aws.go_noc_rd
  }

  target_aws_accounts = var.target_aws_accounts
}

module "principal_iam" {
  source = "./modules/principal-iam"

  providers = {
    aws = aws.go_noc_rd
  }

  sqs_arn = module.sqs.sqs_arn
  target_aws_accounts = var.target_aws_accounts
}

output "principal_account_cloud_custodian_sqs_queue_arn" {
  value = module.sqs.sqs_arn
}

output "principal_account_cc_mailer_service_account_id" {
  value = module.principal_iam.cc_mailer_service_account_id
}

output "principal_account_cc_mailer_service_account_arn" {
  value = module.principal_iam.cc_mailer_service_account_arn
}

output "principal_account_cc_mailer_service_account_name" {
  value = module.principal_iam.cc_mailer_service_account_name
}

output "principal_account_cc_mailer_service_secret_id" {
  value = module.principal_iam.cc_mailer_service_secret_id
}

output "principal_account_cc_mailer_service_secret_access_key" {
  value = module.principal_iam.cc_mailer_service_secret_access_key
  sensitive = true
}

output "principal_account_cc_mailer_role_id" {
  value = module.principal_iam.cc_mailer_role_id
}

output "principal_account_cc_mailer_role_arn" {
  value = module.principal_iam.cc_mailer_role_arn
}

output "principal_account_cc_mailer_role_name" {
  value = module.principal_iam.cc_mailer_role_name
}

output "principal_account_cc_service_account_id" {
  value = module.principal_iam.cc_service_account_id
}

output "principal_account_cc_service_account_arn" {
  value = module.principal_iam.cc_service_account_arn
}

output "principal_account_cc_service_account_name" {
  value = module.principal_iam.cc_service_account_name
}

output "principal_account_cc_service_secret_id" {
  value = module.principal_iam.cc_service_secret_id
}

output "principal_account_cc_service_secret_access_key" {
  value = module.principal_iam.cc_service_secret_access_key
  sensitive = true
}

output "principal_account_cc_role_id" {
  value = module.principal_iam.cc_role_id
}

output "principal_account_cc_role_arn" {
  value = module.principal_iam.cc_role_arn
}

output "principal_account_cc_role_name" {
  value = module.principal_iam.cc_role_name
}

module "rd_dev_k8s_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.rd_dev_k8s
  }

  cc_trusted_user_arn = module.principal_iam.cc_service_account_arn
}

module "go_prod_soc_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.go_prod_soc
  }

  cc_trusted_user_arn = module.principal_iam.cc_service_account_arn
}
