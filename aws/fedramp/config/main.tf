module "fedramp_agencysim_npri_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
}

output "fedramp_agencysim_npri_config_recorder_id" {
  value = module.fedramp_agencysim_npri_config.aws_config_configuration_recorder_id
}

output "fedramp_agencysim_npri_channel_id" {
  value = module.fedramp_agencysim_npri_config.aws_config_delivery_channel_id
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

module "fedramp_network_npr_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_network_npr
  }
}

output "fedramp_network_npr_config_recorder_id" {
  value = module.fedramp_network_npr_config.aws_config_configuration_recorder_id
}

output "fedramp_network_npr_config_channel_id" {
  value = module.fedramp_network_npr_config.aws_config_delivery_channel_id
}

module "fedramp_network_npri_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_network_npri
  }
}

output "fedramp_network_npri_config_recorder_id" {
  value = module.fedramp_network_npri_config.aws_config_configuration_recorder_id
}

output "fedramp_network_npri_config_channel_id" {
  value = module.fedramp_network_npri_config.aws_config_delivery_channel_id
}

module "fedramp_network_prd_config" {
  source = "./modules/config"
  providers = {
    aws = aws.fedramp_network_prd
  }
}

output "fedramp_network_prd_config_recorder_id" {
  value = module.fedramp_network_prd_config.aws_config_configuration_recorder_id
}

output "fedramp_network_prd_config_channel_id" {
  value = module.fedramp_network_prd_config.aws_config_delivery_channel_id
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