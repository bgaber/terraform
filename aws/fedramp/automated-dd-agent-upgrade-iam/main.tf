module "principal_iam" {
  source = "./modules/principal-iam"

  providers = {
    aws = aws.fedramp_security
  }

  target_aws_accounts = var.target_aws_accounts
}

output "principal_account_ddau_service_account_id" {
  value = module.principal_iam.ddau_service_account_id
}

output "principal_account_ddau_service_account_arn" {
  value = module.principal_iam.ddau_service_account_arn
}

output "principal_account_ddau_service_account_name" {
  value = module.principal_iam.ddau_service_account_name
}

output "principal_account_ddau_service_secret_id" {
  value = module.principal_iam.ddau_service_secret_id
}

output "principal_account_ddau_service_secret_access_key" {
  value = module.principal_iam.ddau_service_secret_access_key
  sensitive = true
}

module "fedramp_agencysim_npri_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_agencysim_npri
  }

  ddau_trusted_user_arn = module.principal_iam.ddau_service_account_arn
}

module "fedramp_integration_npr_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_integration_npr
  }

  ddau_trusted_user_arn = module.principal_iam.ddau_service_account_arn
}

module "fedramp_integration_npri_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_integration_npri
  }

  ddau_trusted_user_arn = module.principal_iam.ddau_service_account_arn
}

module "fedramp_integration_prd_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_integration_prd
  }

  ddau_trusted_user_arn = module.principal_iam.ddau_service_account_arn
}

module "fedramp_k8s_npr_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_k8s_npr
  }

  ddau_trusted_user_arn = module.principal_iam.ddau_service_account_arn
}

module "fedramp_k8s_npri_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_k8s_npri
  }

  ddau_trusted_user_arn = module.principal_iam.ddau_service_account_arn
}

module "fedramp_k8s_prd_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_k8s_prd
  }

  ddau_trusted_user_arn = module.principal_iam.ddau_service_account_arn
}

module "fedramp_network_npr_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_network_npr
  }

  ddau_trusted_user_arn = module.principal_iam.ddau_service_account_arn
}

module "fedramp_network_npri_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_network_npri
  }

  ddau_trusted_user_arn = module.principal_iam.ddau_service_account_arn
}

module "fedramp_network_prd_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_network_prd
  }

  ddau_trusted_user_arn = module.principal_iam.ddau_service_account_arn
}

module "fedramp_tools_npri_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_tools_npri
  }

  ddau_trusted_user_arn = module.principal_iam.ddau_service_account_arn
}

module "fedramp_tools_prd_targets_iam" {
  source = "./modules/targets-iam"

  providers = {
    aws = aws.fedramp_tools_prd
  }

  ddau_trusted_user_arn = module.principal_iam.ddau_service_account_arn
}
