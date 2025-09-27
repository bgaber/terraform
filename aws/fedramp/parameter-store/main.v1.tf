module "fedramp_edge_nw_npr_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_edge_nw_npr
  }
}

output "fedramp_edge_nw_npr_ssm_document_arn" {
  value = module.fedramp_edge_nw_npr_ssm.aws_ssm_parameter_arn
}

module "fedramp_edge_nw_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_edge_nw_prd
  }
}

output "fedramp_edge_nw_prd_ssm_document_arn" {
  value = module.fedramp_edge_nw_prd_ssm.aws_ssm_parameter_arn
}

module "fedramp_integration_npr_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_integration_npr
  }
}

output "fedramp_integration_npr_ssm_document_arn" {
  value = module.fedramp_integration_npr_ssm.aws_ssm_parameter_arn
}

module "fedramp_integration_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_integration_npri
  }
}

output "fedramp_integration_npri_ssm_document_arn" {
  value = module.fedramp_integration_npri_ssm.aws_ssm_parameter_arn
}

module "fedramp_integration_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_integration_prd
  }
}

output "fedramp_integration_prd_ssm_document_arn" {
  value = module.fedramp_integration_prd_ssm.aws_ssm_parameter_arn
}

module "fedramp_k8s_npr_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

output "fedramp_k8s_npr_ssm_document_arn" {
  value = module.fedramp_k8s_npr_ssm.aws_ssm_parameter_arn
}

module "fedramp_k8s_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

output "fedramp_k8s_npri_ssm_document_arn" {
  value = module.fedramp_k8s_npri_ssm.aws_ssm_parameter_arn
}

module "fedramp_k8s_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

output "fedramp_k8s_prd_ssm_document_arn" {
  value = module.fedramp_k8s_prd_ssm.aws_ssm_parameter_arn
}

module "fedramp_security_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_security
  }
}

output "fedramp_security_ssm_document_arn" {
  value = module.fedramp_security_ssm.aws_ssm_parameter_arn
}

module "fedramp_tools_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_tools_npri
  }
}

output "fedramp_tools_npri_ssm_document_arn" {
  value = module.fedramp_tools_npri_ssm.aws_ssm_parameter_arn
}

module "fedramp_tools_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_tools_prd
  }
}

output "fedramp_tools_prd_ssm_document_arn" {
  value = module.fedramp_tools_prd_ssm.aws_ssm_parameter_arn
}