module "fedramp_agencysim_npri" {
  source = "./modules/cloudwatch"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
}

output "fedramp_agencysim_npri_event_connection_arn" {
  value = module.fedramp_agencysim_npri.event_connection_arn
}

output "fedramp_agencysim_npri_event_api_destination_arn" {
  value = module.fedramp_agencysim_npri.event_api_destination_arn
}

output "fedramp_agencysim_npri_event_bridge_rule_arn" {
  value = module.fedramp_agencysim_npri.event_bridge_rule_arn
}

output "fedramp_agencysim_npri_event_bridge_rule_iam_role_arn" {
  value = module.fedramp_agencysim_npri.event_bridge_rule_iam_role_arn
}

module "fedramp_integration_npr" {
  source = "./modules/cloudwatch"
  providers = {
    aws = aws.fedramp_integration_npr
  }
}

output "fedramp_integration_npr_event_connection_arn" {
  value = module.fedramp_integration_npr.event_connection_arn
}

output "fedramp_integration_npr_event_api_destination_arn" {
  value = module.fedramp_integration_npr.event_api_destination_arn
}

output "fedramp_integration_npr_event_bridge_rule_arn" {
  value = module.fedramp_integration_npr.event_bridge_rule_arn
}

output "fedramp_integration_npr_event_bridge_rule_iam_role_arn" {
  value = module.fedramp_integration_npr.event_bridge_rule_iam_role_arn
}

module "fedramp_integration_npri" {
  source = "./modules/cloudwatch"
  providers = {
    aws = aws.fedramp_integration_npri
  }
}

output "fedramp_integration_npri_event_connection_arn" {
  value = module.fedramp_integration_npri.event_connection_arn
}

output "fedramp_integration_npri_event_api_destination_arn" {
  value = module.fedramp_integration_npri.event_api_destination_arn
}

output "fedramp_integration_npri_event_bridge_rule_arn" {
  value = module.fedramp_integration_npri.event_bridge_rule_arn
}

output "fedramp_integration_npri_event_bridge_rule_iam_role_arn" {
  value = module.fedramp_integration_npri.event_bridge_rule_iam_role_arn
}

module "fedramp_integration_prd" {
  source = "./modules/cloudwatch"
  providers = {
    aws = aws.fedramp_integration_prd
  }
}

output "fedramp_integration_prd_event_connection_arn" {
  value = module.fedramp_integration_prd.event_connection_arn
}

output "fedramp_integration_prd_event_api_destination_arn" {
  value = module.fedramp_integration_prd.event_api_destination_arn
}

output "fedramp_integration_prd_event_bridge_rule_arn" {
  value = module.fedramp_integration_prd.event_bridge_rule_arn
}

output "fedramp_integration_prd_event_bridge_rule_iam_role_arn" {
  value = module.fedramp_integration_prd.event_bridge_rule_iam_role_arn
}

module "fedramp_k8s_npr" {
  source = "./modules/cloudwatch"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

output "fedramp_k8s_npr_event_connection_arn" {
  value = module.fedramp_k8s_npr.event_connection_arn
}

output "fedramp_k8s_npr_event_api_destination_arn" {
  value = module.fedramp_k8s_npr.event_api_destination_arn
}

output "fedramp_k8s_npr_event_bridge_rule_arn" {
  value = module.fedramp_k8s_npr.event_bridge_rule_arn
}

output "fedramp_k8s_npr_event_bridge_rule_iam_role_arn" {
  value = module.fedramp_k8s_npr.event_bridge_rule_iam_role_arn
}

module "fedramp_k8s_npri" {
  source = "./modules/cloudwatch"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

output "fedramp_k8s_npri_event_connection_arn" {
  value = module.fedramp_k8s_npri.event_connection_arn
}

output "fedramp_k8s_npri_event_api_destination_arn" {
  value = module.fedramp_k8s_npri.event_api_destination_arn
}

output "fedramp_k8s_npri_event_bridge_rule_arn" {
  value = module.fedramp_k8s_npri.event_bridge_rule_arn
}

output "fedramp_k8s_npri_event_bridge_rule_iam_role_arn" {
  value = module.fedramp_k8s_npri.event_bridge_rule_iam_role_arn
}

module "fedramp_k8s_prd" {
  source = "./modules/cloudwatch"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

output "fedramp_k8s_prd_event_connection_arn" {
  value = module.fedramp_k8s_prd.event_connection_arn
}

output "fedramp_k8s_prd_event_api_destination_arn" {
  value = module.fedramp_k8s_prd.event_api_destination_arn
}

output "fedramp_k8s_prd_event_bridge_rule_arn" {
  value = module.fedramp_k8s_prd.event_bridge_rule_arn
}

output "fedramp_k8s_prd_event_bridge_rule_iam_role_arn" {
  value = module.fedramp_k8s_prd.event_bridge_rule_iam_role_arn
}

module "fedramp_security" {
  source = "./modules/cloudwatch"
  providers = {
    aws = aws.fedramp_security
  }
}

output "fedramp_security_event_connection_arn" {
  value = module.fedramp_security.event_connection_arn
}

output "fedramp_security_event_api_destination_arn" {
  value = module.fedramp_security.event_api_destination_arn
}

output "fedramp_security_event_bridge_rule_arn" {
  value = module.fedramp_security.event_bridge_rule_arn
}

output "fedramp_security_event_bridge_rule_iam_role_arn" {
  value = module.fedramp_security.event_bridge_rule_iam_role_arn
}

module "fedramp_tools_npri" {
  source = "./modules/cloudwatch"
  providers = {
    aws = aws.fedramp_tools_npri
  }
}

output "fedramp_tools_npri_event_connection_arn" {
  value = module.fedramp_tools_npri.event_connection_arn
}

output "fedramp_tools_npri_event_api_destination_arn" {
  value = module.fedramp_tools_npri.event_api_destination_arn
}

output "fedramp_tools_npri_event_bridge_rule_arn" {
  value = module.fedramp_tools_npri.event_bridge_rule_arn
}

output "fedramp_tools_npri_event_bridge_rule_iam_role_arn" {
  value = module.fedramp_tools_npri.event_bridge_rule_iam_role_arn
}

module "fedramp_tools_prd" {
  source = "./modules/cloudwatch"
  providers = {
    aws = aws.fedramp_tools_prd
  }
}

output "fedramp_tools_prd_event_connection_arn" {
  value = module.fedramp_tools_prd.event_connection_arn
}

output "fedramp_tools_prd_event_api_destination_arn" {
  value = module.fedramp_tools_prd.event_api_destination_arn
}

output "fedramp_tools_prd_event_bridge_rule_arn" {
  value = module.fedramp_tools_prd.event_bridge_rule_arn
}

output "fedramp_tools_prd_event_bridge_rule_iam_role_arn" {
  value = module.fedramp_tools_prd.event_bridge_rule_iam_role_arn
}
