module "sqs" {
  source = "./modules/sqs"

  providers = {
    aws = aws.fedramp_security
  }
}

module "iam" {
  source = "./modules/iam"

  providers = {
    aws = aws.fedramp_security
  }

  sqs_arn = module.sqs.sqs_arn
}

output "cloud_custodian_sqs_queue_arn" {
  value = module.sqs.sqs_arn
}

output "cc_mailer_service_account_id" {
  value = module.iam.cc_mailer_service_account_id
}

output "cc_mailer_service_account_arn" {
  value = module.iam.cc_mailer_service_account_arn
}

output "cc_mailer_service_account_name" {
  value = module.iam.cc_mailer_service_account_name
}

output "cc_mailer_service_secret_id" {
  value = module.iam.cc_mailer_service_secret_id
}

output "cc_mailer_service_secret_access_key" {
  value = module.iam.cc_mailer_service_secret_access_key
  sensitive = true
}

output "cc_mailer_role_id" {
  value = module.iam.cc_mailer_role_id
}

output "cc_mailer_role_arn" {
  value = module.iam.cc_mailer_role_arn
}

output "cc_mailer_role_name" {
  value = module.iam.cc_mailer_role_name
}

output "cc_service_secret_id" {
  value = module.iam.cc_service_secret_id
}

output "cc_service_secret_access_key" {
  value = module.iam.cc_service_secret_access_key
  sensitive = true
}

output "cc_role_id" {
  value = module.iam.cc_role_id
}

output "cc_role_arn" {
  value = module.iam.cc_role_arn
}

output "cc_role_name" {
  value = module.iam.cc_role_name
}