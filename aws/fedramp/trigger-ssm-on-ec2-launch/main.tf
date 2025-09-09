# Create Shared Linux and Windows SSM Documents
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

module "fedramp_agencysim_npri_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_agencysim_npri_eb_lambda_arn" {
  value = module.fedramp_agencysim_npri_eb_lambda.aws_lambda_function_arn
}

module "fedramp_integration_npr_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_integration_npr
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_integration_npr_eb_lambda_arn" {
  value = module.fedramp_integration_npr_eb_lambda.aws_lambda_function_arn
}

module "fedramp_integration_npri_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_integration_npri
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_integration_npri_eb_lambda_arn" {
  value = module.fedramp_integration_npri_eb_lambda.aws_lambda_function_arn
}

module "fedramp_integration_prd_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_integration_prd
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_integration_prd_eb_lambda_arn" {
  value = module.fedramp_integration_prd_eb_lambda.aws_lambda_function_arn
}

module "fedramp_k8s_npr_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_k8s_npr_eb_lambda_arn" {
  value = module.fedramp_k8s_npr_eb_lambda.aws_lambda_function_arn
}

module "fedramp_k8s_npri_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_k8s_npri_eb_lambda_arn" {
  value = module.fedramp_k8s_npri_eb_lambda.aws_lambda_function_arn
}

module "fedramp_k8s_prd_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_k8s_prd_eb_lambda_arn" {
  value = module.fedramp_k8s_prd_eb_lambda.aws_lambda_function_arn
}

module "fedramp_network_npr_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_network_npr
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_network_npr_eb_lambda_arn" {
  value = module.fedramp_network_npr_eb_lambda.aws_lambda_function_arn
}

module "fedramp_network_npri_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_network_npri
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_network_npri_eb_lambda_arn" {
  value = module.fedramp_network_npri_eb_lambda.aws_lambda_function_arn
}

module "fedramp_network_prd_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_network_prd
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_network_prd_eb_lambda_arn" {
  value = module.fedramp_network_prd_eb_lambda.aws_lambda_function_arn
}

module "fedramp_security_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_security
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_security_eb_lambda_arn" {
  value = module.fedramp_security_eb_lambda.aws_lambda_function_arn
}

module "fedramp_tools_npri_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_tools_npri
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_tools_npri_eb_lambda_arn" {
  value = module.fedramp_tools_npri_eb_lambda.aws_lambda_function_arn
}

module "fedramp_tools_prd_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_tools_prd
  }
  linux_ssm_document_name = module.fedramp_security_ssm.linux_ssm_document_arn
  windows_ssm_document_name = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_tools_prd_eb_lambda_arn" {
  value = module.fedramp_tools_prd_eb_lambda.aws_lambda_function_arn
}