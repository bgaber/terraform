module "fedramp_agencysim_npri_security_hub" {
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
}

output "fedramp_agencysim_npri_security_hub_arn" {
  value = module.fedramp_agencysim_npri_security_hub.aws_securityhub_account_arn
}

output "fedramp_agencysim_npri_security_hub_id" {
  value = module.fedramp_agencysim_npri_security_hub.aws_securityhub_account_id
}

module "fedramp_integration_npr_config" {
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_integration_npr
  }
}

output "fedramp_integration_npr_security_hub_arn" {
  value = module.fedramp_integration_npr_config.aws_securityhub_account_arn
}

output "fedramp_integration_npr_config_security_hub_id" {
  value = module.fedramp_integration_npr_config.aws_securityhub_account_id
}

module "fedramp_integration_npri_config" {
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_integration_npri
  }
}

output "fedramp_integration_npri_security_hub_arn" {
  value = module.fedramp_integration_npri_config.aws_securityhub_account_arn
}

output "fedramp_integration_npri_config_security_hub_id" {
  value = module.fedramp_integration_npri_config.aws_securityhub_account_id
}

module "fedramp_integration_prd_config" {
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_integration_prd
  }
}

output "fedramp_integration_prd_security_hub_arn" {
  value = module.fedramp_integration_prd_config.aws_securityhub_account_arn
}

output "fedramp_integration_prd_config_security_hub_id" {
  value = module.fedramp_integration_prd_config.aws_securityhub_account_id
}

module "fedramp_k8s_npr_config" {
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

output "fedramp_k8s_npr_security_hub_arn" {
  value = module.fedramp_k8s_npr_config.aws_securityhub_account_arn
}

output "fedramp_k8s_npr_config_security_hub_id" {
  value = module.fedramp_k8s_npr_config.aws_securityhub_account_id
}

module "fedramp_k8s_npri_config" {
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

output "fedramp_k8s_npri_security_hub_arn" {
  value = module.fedramp_k8s_npri_config.aws_securityhub_account_arn
}

output "fedramp_k8s_npri_security_hub_id" {
  value = module.fedramp_k8s_npri_config.aws_securityhub_account_id
}

module "fedramp_k8s_prd_config" {
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

output "fedramp_k8s_prd_security_hub_arn" {
  value = module.fedramp_k8s_prd_config.aws_securityhub_account_arn
}

output "fedramp_k8s_prd_config_security_hub_id" {
  value = module.fedramp_k8s_prd_config.aws_securityhub_account_id
}

module "fedramp_network_npr_security_hub" {
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_network_npr
  }
}

output "fedramp_network_npr_security_hub_arn" {
  value = module.fedramp_network_npr_security_hub.aws_securityhub_account_arn
}

output "fedramp_network_npr_security_hub_id" {
  value = module.fedramp_network_npr_security_hub.aws_securityhub_account_id
}

module "fedramp_network_npri_security_hub" {
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_network_npri
  }
}

output "fedramp_network_npri_security_hub_arn" {
  value = module.fedramp_network_npri_security_hub.aws_securityhub_account_arn
}

output "fedramp_network_npri_security_hub_id" {
  value = module.fedramp_network_npri_security_hub.aws_securityhub_account_id
}

module "fedramp_network_prd_security_hub" {
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_network_prd
  }
}

output "fedramp_network_prd_security_hub_arn" {
  value = module.fedramp_network_prd_security_hub.aws_securityhub_account_arn
}

output "fedramp_network_prd_security_hub_id" {
  value = module.fedramp_network_prd_security_hub.aws_securityhub_account_id
}

# Possibly remove because the Security account is the Delegated Admin account for Security Hub
module "fedramp_security_config" {
  count  = terraform.workspace == "dr" ? 1 : 0
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_security
  }
}

output "fedramp_security_security_hub_arn" {
  # value = module.fedramp_security_config.aws_securityhub_account_arn
  value = (
    length(module.fedramp_security_config) > 0 ?
    module.fedramp_security_config[0].aws_securityhub_account_arn :
    null
  )
}

output "fedramp_security_config_security_hub_id" {
  # value = module.fedramp_security_config.aws_securityhub_account_id
  value = (
    length(module.fedramp_security_config) > 0 ?
    module.fedramp_security_config[0].aws_securityhub_account_id :
    null
  )
}

module "fedramp_tools_npri_security_hub" {
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_tools_npri
  }
}

output "fedramp_tools_npri_security_hub_arn" {
  value = module.fedramp_tools_npri_security_hub.aws_securityhub_account_arn
}

output "fedramp_tools_npri_security_hub_id" {
  value = module.fedramp_tools_npri_security_hub.aws_securityhub_account_id
}

module "fedramp_tools_prd_security_hub" {
  source = "./modules/security-hub"
  providers = {
    aws = aws.fedramp_tools_prd
  }
}

output "fedramp_tools_prd_security_hub_arn" {
  value = module.fedramp_tools_npri_security_hub.aws_securityhub_account_arn
}

output "fedramp_tools_prd_security_hub_id" {
  value = module.fedramp_tools_npri_security_hub.aws_securityhub_account_id
}
