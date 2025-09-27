module "fedramp_security_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_security
  }
}

module "fedramp_security_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_security
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_id
}

output "fedramp_security_linux_ssm_document_arn" {
  value = module.fedramp_security_ssm.linux_ssm_document_arn
}

output "fedramp_security_windows_ssm_document_arn" {
  value = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_agencysim_npri_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_edge_nw_npr_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_edge_nw_npr
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_edge_nw_npri_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_edge_nw_npri
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_edge_nw_prd_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_edge_nw_prd
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_integration_npr_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_integration_npr
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_integration_npri_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_integration_npri
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_integration_prd_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_integration_prd
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_k8s_npr_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_k8s_npri_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_k8s_prd_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_network_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_network
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_network_prd_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_network_prd
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_tools_npri_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_tools_npri
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_tools_prd_state_manager" {
  source = "./modules/state-manager"
  providers = {
    aws = aws.fedramp_tools_prd
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}
