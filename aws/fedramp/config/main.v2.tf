module "fedramp_edge_nw_npr_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_edge_nw_npr
  }
}

output "fedramp_edge_nw_npr_config_recorder_id" {
  value = module.fedramp_edge_nw_npr_config.aws_config_configuration_recorder_id
}

output "fedramp_edge_nw_npr_channel_id" {
  value = module.fedramp_edge_nw_npr_config.aws_config_delivery_channel_id
}

module "fedramp_edge_nw_prd_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_edge_nw_prd
  }
}

output "fedramp_edge_nw_prd_config_recorder_id" {
  value = module.fedramp_edge_nw_prd_config.aws_config_configuration_recorder_id
}

output "fedramp_edge_nw_prd_config_channel_id" {
  value = module.fedramp_edge_nw_prd_config.aws_config_delivery_channel_id
}

module "fedramp_integration_npr_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_integration_npr
  }
}

output "fedramp_integration_npr_config_recorder_id" {
  value = module.fedramp_integration_npr_config.aws_config_configuration_recorder_id
}

output "fedramp_integration_npr_config_channel_id" {
  value = module.fedramp_integration_npr_config.aws_config_delivery_channel_id
}

module "fedramp_integration_npri_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_integration_npri
  }
}

output "fedramp_integration_npri_config_recorder_id" {
  value = module.fedramp_integration_npri_config.aws_config_configuration_recorder_id
}

output "fedramp_integration_npri_config_channel_id" {
  value = module.fedramp_integration_npri_config.aws_config_delivery_channel_id
}

module "fedramp_integration_prd_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_integration_prd
  }
}

output "fedramp_integration_prd_config_recorder_id" {
  value = module.fedramp_integration_prd_config.aws_config_configuration_recorder_id
}

output "fedramp_integration_prd_config_channel_id" {
  value = module.fedramp_integration_prd_config.aws_config_delivery_channel_id
}

module "fedramp_k8s_npr_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

output "fedramp_k8s_npr_config_recorder_id" {
  value = module.fedramp_k8s_npr_config.aws_config_configuration_recorder_id
}

output "fedramp_k8s_npr_config_channel_id" {
  value = module.fedramp_k8s_npr_config.aws_config_delivery_channel_id
}

module "fedramp_k8s_npri_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

output "fedramp_k8s_npri_config_recorder_id" {
  value = module.fedramp_k8s_npri_config.aws_config_configuration_recorder_id
}

output "fedramp_k8s_npri_config_channel_id" {
  value = module.fedramp_k8s_npri_config.aws_config_delivery_channel_id
}

module "fedramp_k8s_prd_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

output "fedramp_k8s_prd_config_recorder_id" {
  value = module.fedramp_k8s_prd_config.aws_config_configuration_recorder_id
}

output "fedramp_k8s_prd_config_channel_id" {
  value = module.fedramp_k8s_prd_config.aws_config_delivery_channel_id
}

module "fedramp_security_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_security
  }
}

output "fedramp_security_config_recorder_id" {
  value = module.fedramp_security_config.aws_config_configuration_recorder_id
}

output "fedramp_security_config_channel_id" {
  value = module.fedramp_security_config.aws_config_delivery_channel_id
}

module "fedramp_tools_npri_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_tools_npri
  }
}

output "fedramp_tools_npri_config_recorder_id" {
  value = module.fedramp_tools_npri_config.aws_config_configuration_recorder_id
}

output "fedramp_tools_npri_config_channel_id" {
  value = module.fedramp_tools_npri_config.aws_config_delivery_channel_id
}

module "fedramp_tools_prd_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_tools_prd
  }
}

output "fedramp_tools_prd_config_recorder_id" {
  value = module.fedramp_tools_prd_config.aws_config_configuration_recorder_id
}

output "fedramp_tools_prd_config_channel_id" {
  value = module.fedramp_tools_prd_config.aws_config_delivery_channel_id
}