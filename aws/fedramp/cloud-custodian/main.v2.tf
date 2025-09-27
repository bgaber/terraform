module "sqs" {
  source = "./modules/sqs"

  providers = {
    aws = aws.fedramp_security
  }
}

module "principal_iam" {
  source = "./modules/principal-iam"

  providers = {
    aws = aws.fedramp_security
  }

  sqs_arn = module.sqs.sqs_arn
}

output "cloud_custodian_sqs_queue_arn" {
  value = module.sqs.sqs_arn
}

output "cc_mailer_service_account_id" {
  value = module.principal_iam.cc_mailer_service_account_id
}

output "cc_mailer_service_account_arn" {
  value = module.principal_iam.cc_mailer_service_account_arn
}

output "cc_mailer_service_account_name" {
  value = module.principal_iam.cc_mailer_service_account_name
}

output "cc_mailer_service_secret_id" {
  value = module.principal_iam.cc_mailer_service_secret_id
}

output "cc_mailer_service_secret_access_key" {
  value = module.principal_iam.cc_mailer_service_secret_access_key
  sensitive = true
}

output "cc_mailer_role_id" {
  value = module.principal_iam.cc_mailer_role_id
}

output "cc_mailer_role_arn" {
  value = module.principal_iam.cc_mailer_role_arn
}

output "cc_mailer_role_name" {
  value = module.principal_iam.cc_mailer_role_name
}

output "cc_service_secret_id" {
  value = module.principal_iam.cc_service_secret_id
}

output "cc_service_secret_access_key" {
  value = module.principal_iam.cc_service_secret_access_key
  sensitive = true
}

output "cc_role_id" {
  value = module.principal_iam.cc_role_id
}

output "cc_role_arn" {
  value = module.principal_iam.cc_role_arn
}

output "cc_role_name" {
  value = module.principal_iam.cc_role_name
}

module "fedramp_agencysim_npri_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_agencysim_npri
  }
}

module "fedramp_integration_npr_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_integration_npr
  }
}

module "fedramp_integration_npri_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_integration_npri
  }
}

module "fedramp_integration_prd_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_integration_prd
  }
}

module "fedramp_k8s_npr_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

module "fedramp_k8s_npri_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

module "fedramp_k8s_prd_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

module "fedramp_network_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_network
  }
}

module "fedramp_network_prd_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_network_prd
  }
}

module "fedramp_tools_npri_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_tools_npri
  }
}

module "fedramp_tools_prd_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_tools_prd
  }
}
