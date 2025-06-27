module "fedramp_security_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_security
  }
}

output "fedramp_security_linux_ssm_document_arn" {
  value = module.fedramp_security_ssm.linux_ssm_document_arn
}

output "fedramp_security_windows_ssm_document_arn" {
  value = module.fedramp_security_ssm.windows_ssm_document_arn
}

module "fedramp_edge_nw_npr_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_edge_nw_npr
  }
}

output "fedramp_edge_nw_npr_linux_ssm_document_arn" {
  value = module.fedramp_edge_nw_npr_ssm.linux_ssm_document_arn
}

output "fedramp_edge_nw_npr_windows_ssm_document_arn" {
  value = module.fedramp_edge_nw_npr_ssm.windows_ssm_document_arn
}

module "fedramp_edge_nw_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_edge_nw_prd
  }
}

output "fedramp_edge_nw_prd_linux_ssm_document_arn" {
  value = module.fedramp_edge_nw_prd_ssm.linux_ssm_document_arn
}

output "fedramp_edge_nw_prd_windows_ssm_document_arn" {
  value = module.fedramp_edge_nw_prd_ssm.windows_ssm_document_arn
}

module "fedramp_integration_npr_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_integration_npr
  }
}

output "fedramp_integration_npr_linux_ssm_document_arn" {
  value = module.fedramp_integration_npr_ssm.linux_ssm_document_arn
}

output "fedramp_integration_npr_windows_ssm_document_arn" {
  value = module.fedramp_integration_npr_ssm.windows_ssm_document_arn
}

module "fedramp_integration_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_integration_npri
  }
}

output "fedramp_integration_npri_linux_ssm_document_arn" {
  value = module.fedramp_integration_npri_ssm.linux_ssm_document_arn
}

output "fedramp_integration_npri_windows_ssm_document_arn" {
  value = module.fedramp_integration_npri_ssm.windows_ssm_document_arn
}

module "fedramp_integration_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_integration_prd
  }
}

output "fedramp_integration_prd_linux_ssm_document_arn" {
  value = module.fedramp_integration_prd_ssm.linux_ssm_document_arn
}

output "fedramp_integration_prd_windows_ssm_document_arn" {
  value = module.fedramp_integration_prd_ssm.windows_ssm_document_arn
}

module "fedramp_k8s_npr_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

output "fedramp_k8s_npr_linux_ssm_document_arn" {
  value = module.fedramp_k8s_npr_ssm.linux_ssm_document_arn
}

output "fedramp_k8s_npr_windows_ssm_document_arn" {
  value = module.fedramp_k8s_npr_ssm.windows_ssm_document_arn
}

module "fedramp_k8s_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

output "fedramp_k8s_npri_linux_ssm_document_arn" {
  value = module.fedramp_k8s_npri_ssm.linux_ssm_document_arn
}

output "fedramp_k8s_npri_windows_ssm_document_arn" {
  value = module.fedramp_k8s_npri_ssm.windows_ssm_document_arn
}

module "fedramp_k8s_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

output "fedramp_k8s_prd_linux_ssm_document_arn" {
  value = module.fedramp_k8s_prd_ssm.linux_ssm_document_arn
}

output "fedramp_k8s_prd_windows_ssm_document_arn" {
  value = module.fedramp_k8s_prd_ssm.windows_ssm_document_arn
}

module "fedramp_tools_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_tools
  }
}

output "fedramp_tools_linux_ssm_document_arn" {
  value = module.fedramp_tools_ssm.linux_ssm_document_arn
}

output "fedramp_tools_windows_ssm_document_arn" {
  value = module.fedramp_tools_ssm.windows_ssm_document_arn
}