module "fedramp_agencysim_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
}

module "fedramp_agencysim_npri_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
  linux_ssm_document_name = module.fedramp_agencysim_npri_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_agencysim_npri_ssm.windows_ssm_document_id
}

output "fedramp_agencysim_npri_linux_ssm_document_arn" {
  value = module.fedramp_agencysim_npri_ssm.linux_ssm_document_arn
}

output "fedramp_agencysim_npri_windows_ssm_document_arn" {
  value = module.fedramp_agencysim_npri_ssm.windows_ssm_document_arn
}

output "fedramp_agencysim_npri_eb_lambda_arn" {
  value = module.fedramp_agencysim_npri_eb_lambda.aws_lambda_function_arn
}

module "fedramp_edge_nw_npr_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_edge_nw_npr
  }
}

module "fedramp_edge_nw_npr_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_edge_nw_npr
  }
  linux_ssm_document_name = module.fedramp_edge_nw_npr_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_edge_nw_npr_ssm.windows_ssm_document_id
}

output "fedramp_edge_nw_npr_linux_ssm_document_arn" {
  value = module.fedramp_edge_nw_npr_ssm.linux_ssm_document_arn
}

output "fedramp_edge_nw_npr_windows_ssm_document_arn" {
  value = module.fedramp_edge_nw_npr_ssm.windows_ssm_document_arn
}

output "fedramp_edge_nw_npr_eb_lambda_arn" {
  value = module.fedramp_edge_nw_npr_eb_lambda.aws_lambda_function_arn
}

module "fedramp_edge_nw_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_edge_nw_npri
  }
}

module "fedramp_edge_nw_npri_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_edge_nw_npri
  }
  linux_ssm_document_name = module.fedramp_edge_nw_npri_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_edge_nw_npri_ssm.windows_ssm_document_id
}

output "fedramp_edge_nw_npri_linux_ssm_document_arn" {
  value = module.fedramp_edge_nw_npri_ssm.linux_ssm_document_arn
}

output "fedramp_edge_nw_npri_windows_ssm_document_arn" {
  value = module.fedramp_edge_nw_npri_ssm.windows_ssm_document_arn
}

output "fedramp_edge_nw_npri_eb_lambda_arn" {
  value = module.fedramp_edge_nw_npri_eb_lambda.aws_lambda_function_arn
}

module "fedramp_edge_nw_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_edge_nw_prd
  }
}

module "fedramp_edge_nw_prd_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_edge_nw_prd
  }
  linux_ssm_document_name = module.fedramp_edge_nw_prd_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_edge_nw_prd_ssm.windows_ssm_document_id
}

output "fedramp_edge_nw_prd_linux_ssm_document_arn" {
  value = module.fedramp_edge_nw_prd_ssm.linux_ssm_document_arn
}

output "fedramp_edge_nw_prd_windows_ssm_document_arn" {
  value = module.fedramp_edge_nw_prd_ssm.windows_ssm_document_arn
}

output "fedramp_edge_nw_prd_eb_lambda_arn" {
  value = module.fedramp_edge_nw_prd_eb_lambda.aws_lambda_function_arn
}

module "fedramp_integration_npr_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_integration_npr
  }
}

module "fedramp_integration_npr_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_integration_npr
  }
  linux_ssm_document_name = module.fedramp_integration_npr_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_integration_npr_ssm.windows_ssm_document_id
}

output "fedramp_integration_npr_linux_ssm_document_arn" {
  value = module.fedramp_integration_npr_ssm.linux_ssm_document_arn
}

output "fedramp_integration_npr_windows_ssm_document_arn" {
  value = module.fedramp_integration_npr_ssm.windows_ssm_document_arn
}

output "fedramp_integration_npr_eb_lambda_arn" {
  value = module.fedramp_integration_npr_eb_lambda.aws_lambda_function_arn
}

module "fedramp_integration_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_integration_npri
  }
}

module "fedramp_integration_npri_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_integration_npri
  }
  linux_ssm_document_name = module.fedramp_integration_npri_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_integration_npri_ssm.windows_ssm_document_id
}

output "fedramp_integration_npri_linux_ssm_document_arn" {
  value = module.fedramp_integration_npri_ssm.linux_ssm_document_arn
}

output "fedramp_integration_npri_windows_ssm_document_arn" {
  value = module.fedramp_integration_npri_ssm.windows_ssm_document_arn
}

output "fedramp_integration_npri_eb_lambda_arn" {
  value = module.fedramp_integration_npri_eb_lambda.aws_lambda_function_arn
}

module "fedramp_integration_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_integration_prd
  }
}

module "fedramp_integration_prd_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_integration_prd
  }
  linux_ssm_document_name = module.fedramp_integration_prd_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_integration_prd_ssm.windows_ssm_document_id
}

output "fedramp_integration_prd_linux_ssm_document_arn" {
  value = module.fedramp_integration_prd_ssm.linux_ssm_document_arn
}

output "fedramp_integration_prd_windows_ssm_document_arn" {
  value = module.fedramp_integration_prd_ssm.windows_ssm_document_arn
}

output "fedramp_integration_prd_eb_lambda_arn" {
  value = module.fedramp_integration_prd_eb_lambda.aws_lambda_function_arn
}

module "fedramp_k8s_npr_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

module "fedramp_k8s_npr_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
  linux_ssm_document_name = module.fedramp_k8s_npr_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_k8s_npr_ssm.windows_ssm_document_id
}

output "fedramp_k8s_npr_linux_ssm_document_arn" {
  value = module.fedramp_k8s_npr_ssm.linux_ssm_document_arn
}

output "fedramp_k8s_npr_windows_ssm_document_arn" {
  value = module.fedramp_k8s_npr_ssm.windows_ssm_document_arn
}

output "fedramp_k8s_npr_eb_lambda_arn" {
  value = module.fedramp_k8s_npr_eb_lambda.aws_lambda_function_arn
}

module "fedramp_k8s_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

module "fedramp_k8s_npri_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
  linux_ssm_document_name = module.fedramp_k8s_npri_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_k8s_npri_ssm.windows_ssm_document_id
}

output "fedramp_k8s_npri_linux_ssm_document_arn" {
  value = module.fedramp_k8s_npri_ssm.linux_ssm_document_arn
}

output "fedramp_k8s_npri_windows_ssm_document_arn" {
  value = module.fedramp_k8s_npri_ssm.windows_ssm_document_arn
}

output "fedramp_k8s_npri_eb_lambda_arn" {
  value = module.fedramp_k8s_npri_eb_lambda.aws_lambda_function_arn
}

module "fedramp_k8s_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

module "fedramp_k8s_prd_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
  linux_ssm_document_name = module.fedramp_k8s_prd_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_k8s_prd_ssm.windows_ssm_document_id
}

output "fedramp_k8s_prd_linux_ssm_document_arn" {
  value = module.fedramp_k8s_prd_ssm.linux_ssm_document_arn
}

output "fedramp_k8s_prd_windows_ssm_document_arn" {
  value = module.fedramp_k8s_prd_ssm.windows_ssm_document_arn
}

output "fedramp_k8s_prd_eb_lambda_arn" {
  value = module.fedramp_k8s_prd_eb_lambda.aws_lambda_function_arn
}

module "fedramp_network_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_network
  }
}

module "fedramp_network_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_network
  }
  linux_ssm_document_name = module.fedramp_network_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_network_ssm.windows_ssm_document_id
}

output "fedramp_network_linux_ssm_document_arn" {
  value = module.fedramp_network_ssm.linux_ssm_document_arn
}

output "fedramp_network_windows_ssm_document_arn" {
  value = module.fedramp_network_ssm.windows_ssm_document_arn
}

output "fedramp_network_eb_lambda_arn" {
  value = module.fedramp_network_eb_lambda.aws_lambda_function_arn
}

module "fedramp_security_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_security
  }
}

module "fedramp_security_eb_lambda" {
  source = "./modules/eb_lambda"
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

output "fedramp_security_eb_lambda_arn" {
  value = module.fedramp_security_eb_lambda.aws_lambda_function_arn
}

module "fedramp_tools_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_tools_npri
  }
}

module "fedramp_tools_npri_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_tools_npri
  }
  linux_ssm_document_name = module.fedramp_tools_npri_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_tools_npri_ssm.windows_ssm_document_id
}

output "fedramp_tools_npri_linux_ssm_document_arn" {
  value = module.fedramp_tools_npri_ssm.linux_ssm_document_arn
}

output "fedramp_tools_npri_windows_ssm_document_arn" {
  value = module.fedramp_tools_npri_ssm.windows_ssm_document_arn
}

output "fedramp_tools_npri_eb_lambda_arn" {
  value = module.fedramp_tools_npri_eb_lambda.aws_lambda_function_arn
}

module "fedramp_tools_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_tools_prd
  }
}

module "fedramp_tools_prd_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_tools_prd
  }
  linux_ssm_document_name = module.fedramp_tools_prd_ssm.linux_ssm_document_id
  windows_ssm_document_name = module.fedramp_tools_prd_ssm.windows_ssm_document_id
}

output "fedramp_tools_prd_linux_ssm_document_arn" {
  value = module.fedramp_tools_prd_ssm.linux_ssm_document_arn
}

output "fedramp_tools_prd_windows_ssm_document_arn" {
  value = module.fedramp_tools_prd_ssm.windows_ssm_document_arn
}

output "fedramp_tools_prd_eb_lambda_arn" {
  value = module.fedramp_tools_prd_eb_lambda.aws_lambda_function_arn
}