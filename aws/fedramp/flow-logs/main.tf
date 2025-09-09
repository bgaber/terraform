module "fedramp_security_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_security
  }
}

output "fedramp_security_flow_logs_arn" {
  value = module.fedramp_security_flow_logs.vpcs_id_arn_name
}

output "fedramp_security_flow_logs_s3_arn" {
  value = module.fedramp_security_flow_logs.current_flow_log_s3_arn
}

module "fedramp_agencysim_npri_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
}

output "fedramp_agencysim_npri_flow_logs_arn" {
  value = module.fedramp_agencysim_npri_flow_logs.vpcs_id_arn_name
}

output "fedramp_agencysim_npri_flow_logs_s3_arn" {
  value = module.fedramp_agencysim_npri_flow_logs.current_flow_log_s3_arn
}

module "fedramp_integration_npr_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_integration_npr
  }
}

output "fedramp_integration_npr_flow_logs_arn" {
  value = module.fedramp_integration_npr_flow_logs.vpcs_id_arn_name
}

output "fedramp_integration_npr_flow_logs_s3_arn" {
  value = module.fedramp_integration_npr_flow_logs.current_flow_log_s3_arn
}

module "fedramp_integration_npri_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_integration_npri
  }
}

output "fedramp_integration_npri_flow_logs_arn" {
  value = module.fedramp_integration_npri_flow_logs.vpcs_id_arn_name
}

output "fedramp_integration_npri_flow_logs_s3_arn" {
  value = module.fedramp_integration_npri_flow_logs.current_flow_log_s3_arn
}

module "fedramp_integration_prd_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_integration_prd
  }
}

output "fedramp_integration_prd_flow_logs_arn" {
  value = module.fedramp_integration_prd_flow_logs.vpcs_id_arn_name
}

output "fedramp_integration_prd_flow_logs_s3_arn" {
  value = module.fedramp_integration_prd_flow_logs.current_flow_log_s3_arn
}

module "fedramp_k8s_npr_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

output "fedramp_k8s_npr_flow_logs_arn" {
  value = module.fedramp_k8s_npr_flow_logs.vpcs_id_arn_name
}

output "fedramp_k8s_npr_flow_logs_s3_arn" {
  value = module.fedramp_k8s_npr_flow_logs.current_flow_log_s3_arn
}

module "fedramp_k8s_npri_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

output "fedramp_k8s_npri_flow_logs_arn" {
  value = module.fedramp_k8s_npri_flow_logs.vpcs_id_arn_name
}

output "fedramp_k8s_npri_flow_logs_s3_arn" {
  value = module.fedramp_k8s_npri_flow_logs.current_flow_log_s3_arn
}

module "fedramp_k8s_prd_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

output "fedramp_k8s_prd_flow_logs_arn" {
  value = module.fedramp_k8s_prd_flow_logs.vpcs_id_arn_name
}

output "fedramp_k8s_prd_flow_logs_s3_arn" {
  value = module.fedramp_k8s_prd_flow_logs.current_flow_log_s3_arn
}

module "fedramp_network_npr_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_network_npr
  }
}

output "fedramp_network_npr_flow_logs_arn" {
  value = module.fedramp_network_npr_flow_logs.vpcs_id_arn_name
}

output "fedramp_network_npr_flow_logs_s3_arn" {
  value = module.fedramp_network_npr_flow_logs.current_flow_log_s3_arn
}

module "fedramp_network_npri_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_network_npri
  }
}

output "fedramp_network_npri_flow_logs_arn" {
  value = module.fedramp_network_npri_flow_logs.vpcs_id_arn_name
}

output "fedramp_network_npri_flow_logs_s3_arn" {
  value = module.fedramp_network_npri_flow_logs.current_flow_log_s3_arn
}

module "fedramp_network_prd_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_network_prd
  }
}

output "fedramp_network_prd_flow_logs_arn" {
  value = module.fedramp_network_prd_flow_logs.vpcs_id_arn_name
}

output "fedramp_network_prd_flow_logs_s3_arn" {
  value = module.fedramp_network_prd_flow_logs.current_flow_log_s3_arn
}

module "fedramp_tools_npri_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_tools_npri
  }
}

output "fedramp_tools_npri_flow_logs_arn" {
  value = module.fedramp_tools_npri_flow_logs.vpcs_id_arn_name
}

output "fedramp_tools_npri_flow_logs_s3_arn" {
  value = module.fedramp_tools_npri_flow_logs.current_flow_log_s3_arn
}

module "fedramp_tools_prd_flow_logs" {
  source = "./modules/flow-logs"
  providers = {
    aws = aws.fedramp_tools_prd
  }
}

output "fedramp_tools_prd_flow_logs_arn" {
  value = module.fedramp_tools_prd_flow_logs.vpcs_id_arn_name
}

output "fedramp_tools_prd_flow_logs_s3_arn" {
  value = module.fedramp_tools_prd_flow_logs.current_flow_log_s3_arn
}
