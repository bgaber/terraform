module "fedramp_edge_nw_npr" {
  source = "./modules/vpc-flowlogs"
  providers = {
    aws = aws.fedramp_edge_nw_npr
  }
}

output "fedramp_edge_nw_npr_trust_anchor_arn" {
  value = module.fedramp_edge_nw_npr.aws_rolesanywhere_trust_anchor_arn
}

output "fedramp_edge_nw_npr_trust_anchor_id" {
  value = module.fedramp_edge_nw_npr.aws_rolesanywhere_trust_anchor_id
}

output "fedramp_edge_nw_npr_profile_arn" {
  value = module.fedramp_edge_nw_npr.aws_rolesanywhere_profile_arn
}

output "fedramp_edge_nw_npr_profile_id" {
  value = module.fedramp_edge_nw_npr.aws_rolesanywhere_profile_arn
}

module "fedramp_edge_nw_prd" {
  source = "./modules/vpc-flowlogs"
  providers = {
    aws = aws.fedramp_edge_nw_prd
  }
}

output "fedramp_edge_nw_prd_trust_anchor_arn" {
  value = module.fedramp_edge_nw_prd.aws_rolesanywhere_trust_anchor_arn
}

output "fedramp_edge_nw_prd_trust_anchor_id" {
  value = module.fedramp_edge_nw_prd.aws_rolesanywhere_trust_anchor_id
}

output "fedramp_edge_nw_prd_profile_arn" {
  value = module.fedramp_edge_nw_prd.aws_rolesanywhere_profile_arn
}

output "fedramp_edge_nw_prd_profile_id" {
  value = module.fedramp_edge_nw_prd.aws_rolesanywhere_profile_arn
}

module "fedramp_integration_npr" {
  source = "./modules/vpc-flowlogs"
  providers = {
    aws = aws.fedramp_integration_npr
  }
}

output "fedramp_integration_npr_trust_anchor_arn" {
  value = module.fedramp_integration_npr.aws_rolesanywhere_trust_anchor_arn
}

output "fedramp_integration_npr_trust_anchor_id" {
  value = module.fedramp_integration_npr.aws_rolesanywhere_trust_anchor_id
}

output "fedramp_integration_npr_profile_arn" {
  value = module.fedramp_integration_npr.aws_rolesanywhere_profile_arn
}

output "fedramp_integration_npr_profile_id" {
  value = module.fedramp_integration_npr.aws_rolesanywhere_profile_arn
}

module "fedramp_integration_npri" {
  source = "./modules/vpc-flowlogs"
  providers = {
    aws = aws.fedramp_integration_npri
  }
}

output "fedramp_integration_npri_trust_anchor_arn" {
  value = module.fedramp_integration_npri.aws_rolesanywhere_trust_anchor_arn
}

output "fedramp_integration_npri_trust_anchor_id" {
  value = module.fedramp_integration_npri.aws_rolesanywhere_trust_anchor_id
}

output "fedramp_integration_npri_profile_arn" {
  value = module.fedramp_integration_npri.aws_rolesanywhere_profile_arn
}

output "fedramp_integration_npri_profile_id" {
  value = module.fedramp_integration_npri.aws_rolesanywhere_profile_arn
}

module "fedramp_integration_prd" {
  source = "./modules/vpc-flowlogs"
  providers = {
    aws = aws.fedramp_integration_prd
  }
}

output "fedramp_integration_prd_trust_anchor_arn" {
  value = module.fedramp_integration_prd.aws_rolesanywhere_trust_anchor_arn
}

output "fedramp_integration_prd_trust_anchor_id" {
  value = module.fedramp_integration_prd.aws_rolesanywhere_trust_anchor_id
}

output "fedramp_integration_prd_profile_arn" {
  value = module.fedramp_integration_prd.aws_rolesanywhere_profile_arn
}

output "fedramp_integration_prd_profile_id" {
  value = module.fedramp_integration_prd.aws_rolesanywhere_profile_arn
}

module "fedramp_k8s_npr" {
  source = "./modules/vpc-flowlogs"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

output "fedramp_k8s_npr_trust_anchor_arn" {
  value = module.fedramp_k8s_npr.aws_rolesanywhere_trust_anchor_arn
}

output "fedramp_k8s_npr_trust_anchor_id" {
  value = module.fedramp_k8s_npr.aws_rolesanywhere_trust_anchor_id
}

output "fedramp_k8s_npr_profile_arn" {
  value = module.fedramp_k8s_npr.aws_rolesanywhere_profile_arn
}

output "fedramp_k8s_npr_profile_id" {
  value = module.fedramp_k8s_npr.aws_rolesanywhere_profile_arn
}

module "fedramp_k8s_npri" {
  source = "./modules/vpc-flowlogs"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

output "fedramp_k8s_npri_trust_anchor_arn" {
  value = module.fedramp_k8s_npri.aws_rolesanywhere_trust_anchor_arn
}

output "fedramp_k8s_npri_trust_anchor_id" {
  value = module.fedramp_k8s_npri.aws_rolesanywhere_trust_anchor_id
}

output "fedramp_k8s_npri_profile_arn" {
  value = module.fedramp_k8s_npri.aws_rolesanywhere_profile_arn
}

output "fedramp_k8s_npri_profile_id" {
  value = module.fedramp_k8s_npri.aws_rolesanywhere_profile_arn
}

module "fedramp_k8s_prd" {
  source = "./modules/vpc-flowlogs"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

output "fedramp_k8s_prd_trust_anchor_arn" {
  value = module.fedramp_k8s_prd.aws_rolesanywhere_trust_anchor_arn
}

output "fedramp_k8s_prd_trust_anchor_id" {
  value = module.fedramp_k8s_prd.aws_rolesanywhere_trust_anchor_id
}

output "fedramp_k8s_prd_profile_arn" {
  value = module.fedramp_k8s_prd.aws_rolesanywhere_profile_arn
}

output "fedramp_k8s_prd_profile_id" {
  value = module.fedramp_k8s_prd.aws_rolesanywhere_profile_arn
}

module "fedramp_security" {
  source = "./modules/vpc-flowlogs"
  providers = {
    aws = aws.fedramp_security
  }
}

output "fedramp_security_trust_anchor_arn" {
  value = module.fedramp_security.aws_rolesanywhere_trust_anchor_arn
}

output "fedramp_security_trust_anchor_id" {
  value = module.fedramp_security.aws_rolesanywhere_trust_anchor_id
}

output "fedramp_security_profile_arn" {
  value = module.fedramp_security.aws_rolesanywhere_profile_arn
}

output "fedramp_security_profile_id" {
  value = module.fedramp_security.aws_rolesanywhere_profile_arn
}

module "fedramp_tools_npri" {
  source = "./modules/vpc-flowlogs"
  providers = {
    aws = aws.fedramp_tools_npri
  }
}

output "fedramp_tools_npri_trust_anchor_arn" {
  value = module.fedramp_tools_npri.aws_rolesanywhere_trust_anchor_arn
}

output "fedramp_tools_npri_trust_anchor_id" {
  value = module.fedramp_tools_npri.aws_rolesanywhere_trust_anchor_id
}

output "fedramp_tools_npri_profile_arn" {
  value = module.fedramp_tools_npri.aws_rolesanywhere_profile_arn
}

output "fedramp_tools_npri_profile_id" {
  value = module.fedramp_tools_npri.aws_rolesanywhere_profile_arn
}

module "fedramp_tools_prd" {
  source = "./modules/vpc-flowlogs"
  providers = {
    aws = aws.fedramp_tools_prd
  }
}

output "fedramp_tools_prd_trust_anchor_arn" {
  value = module.fedramp_tools_prd.aws_rolesanywhere_trust_anchor_arn
}

output "fedramp_tools_prd_trust_anchor_id" {
  value = module.fedramp_tools_prd.aws_rolesanywhere_trust_anchor_id
}

output "fedramp_tools_prd_profile_arn" {
  value = module.fedramp_tools_prd.aws_rolesanywhere_profile_arn
}

output "fedramp_tools_prd_profile_id" {
  value = module.fedramp_tools_prd.aws_rolesanywhere_profile_arn
}
