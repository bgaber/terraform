module "fedramp_agencysim_npri_access_analyzer" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
}

output "fedramp_agencysim_npri_iam_access_analyzer_arn" {
  value = module.fedramp_agencysim_npri_access_analyzer.aws_iam_access_analyzer_arn
}

output "fedramp_agencysim_npri_iam_access_analyzer_id" {
  value = module.fedramp_agencysim_npri_access_analyzer.aws_iam_access_analyzer_id
}

module "fedramp_integration_npr_config" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_integration_npr
  }
}

output "fedramp_integration_npr_iam_access_analyzer_arn" {
  value = module.fedramp_integration_npr_config.aws_iam_access_analyzer_arn
}

output "fedramp_integration_npr_config_iam_access_analyzer_id" {
  value = module.fedramp_integration_npr_config.aws_iam_access_analyzer_id
}

module "fedramp_integration_npri_config" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_integration_npri
  }
}

output "fedramp_integration_npri_iam_access_analyzer_arn" {
  value = module.fedramp_integration_npri_config.aws_iam_access_analyzer_arn
}

output "fedramp_integration_npri_config_iam_access_analyzer_id" {
  value = module.fedramp_integration_npri_config.aws_iam_access_analyzer_id
}

module "fedramp_integration_prd_config" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_integration_prd
  }
}

output "fedramp_integration_prd_iam_access_analyzer_arn" {
  value = module.fedramp_integration_prd_config.aws_iam_access_analyzer_arn
}

output "fedramp_integration_prd_config_iam_access_analyzer_id" {
  value = module.fedramp_integration_prd_config.aws_iam_access_analyzer_id
}

module "fedramp_k8s_npr_config" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

output "fedramp_k8s_npr_iam_access_analyzer_arn" {
  value = module.fedramp_k8s_npr_config.aws_iam_access_analyzer_arn
}

output "fedramp_k8s_npr_config_iam_access_analyzer_id" {
  value = module.fedramp_k8s_npr_config.aws_iam_access_analyzer_id
}

module "fedramp_k8s_npri_config" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

output "fedramp_k8s_npri_iam_access_analyzer_arn" {
  value = module.fedramp_k8s_npri_config.aws_iam_access_analyzer_arn
}

output "fedramp_k8s_npri_config_iam_access_analyzer_id" {
  value = module.fedramp_k8s_npri_config.aws_iam_access_analyzer_id
}

module "fedramp_k8s_prd_config" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

output "fedramp_k8s_prd_iam_access_analyzer_arn" {
  value = module.fedramp_k8s_prd_config.aws_iam_access_analyzer_arn
}

output "fedramp_k8s_prd_config_iam_access_analyzer_id" {
  value = module.fedramp_k8s_prd_config.aws_iam_access_analyzer_id
}

module "fedramp_network_npr_access_analyzer" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_network_npr
  }
}

output "fedramp_network_npr_iam_access_analyzer_arn" {
  value = module.fedramp_network_npr_access_analyzer.aws_iam_access_analyzer_arn
}

output "fedramp_network_npr_iam_access_analyzer_id" {
  value = module.fedramp_network_npr_access_analyzer.aws_iam_access_analyzer_id
}

module "fedramp_network_npri_access_analyzer" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_network_npri
  }
}

output "fedramp_network_npri_iam_access_analyzer_arn" {
  value = module.fedramp_network_npri_access_analyzer.aws_iam_access_analyzer_arn
}

output "fedramp_network_npri_iam_access_analyzer_id" {
  value = module.fedramp_network_npri_access_analyzer.aws_iam_access_analyzer_id
}

module "fedramp_network_prd_access_analyzer" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_network_prd
  }
}

output "fedramp_network_prd_iam_access_analyzer_arn" {
  value = module.fedramp_network_prd_access_analyzer.aws_iam_access_analyzer_arn
}

output "fedramp_network_prd_iam_access_analyzer_id" {
  value = module.fedramp_network_prd_access_analyzer.aws_iam_access_analyzer_id
}

module "fedramp_security_config" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_security
  }
}

output "fedramp_security_iam_access_analyzer_arn" {
  value = module.fedramp_security_config.aws_iam_access_analyzer_arn
}

output "fedramp_security_config_iam_access_analyzer_id" {
  value = module.fedramp_security_config.aws_iam_access_analyzer_id
}

module "fedramp_tools_npri_access_analyzer" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_tools_npri
  }
}

output "fedramp_tools_npri_iam_access_analyzer_arn" {
  value = module.fedramp_tools_npri_access_analyzer.aws_iam_access_analyzer_arn
}

output "fedramp_tools_npri_iam_access_analyzer_id" {
  value = module.fedramp_tools_npri_access_analyzer.aws_iam_access_analyzer_id
}

module "fedramp_tools_prd_access_analyzer" {
  source = "./modules/iam-access-analyzer"
  providers = {
    aws = aws.fedramp_tools_prd
  }
}

output "fedramp_tools_prd_iam_access_analyzer_arn" {
  value = module.fedramp_tools_prd_access_analyzer.aws_iam_access_analyzer_arn
}

output "fedramp_tools_prd_iam_access_analyzer_id" {
  value = module.fedramp_tools_prd_access_analyzer.aws_iam_access_analyzer_id
}
