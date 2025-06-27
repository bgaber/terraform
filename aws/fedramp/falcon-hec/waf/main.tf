module "fedramp_k8s_npr" {
  source = "./modules/waf"
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
  source = "./modules/waf"
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
  source = "./modules/waf"
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
