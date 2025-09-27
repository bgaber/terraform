module "fedramp_access_analyzer_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_access_analyzer
  }
}

module "fedramp_access_analyzer_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_access_analyzer
  }
  ssm_document_name = module.fedramp_access_analyzer_ssm.aws_ssm_document_id
}

output "fedramp_access_analyzer_ssm_document_arn" {
  value = module.fedramp_access_analyzer_ssm.aws_ssm_document_arn
}

output "fedramp_access_analyzer_eb_lambda_arn" {
  value = module.fedramp_access_analyzer_eb_lambda.aws_lambda_function_arn
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
  ssm_document_name = module.fedramp_edge_nw_npr_ssm.aws_ssm_document_id
}

output "fedramp_edge_nw_npr_ssm_document_arn" {
  value = module.fedramp_edge_nw_npr_ssm.aws_ssm_document_arn
}

output "fedramp_edge_nw_npr_eb_lambda_arn" {
  value = module.fedramp_edge_nw_npr_eb_lambda.aws_lambda_function_arn
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
  ssm_document_name = module.fedramp_edge_nw_prd_ssm.aws_ssm_document_id
}

output "fedramp_edge_nw_prd_ssm_document_arn" {
  value = module.fedramp_edge_nw_prd_ssm.aws_ssm_document_arn
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
  ssm_document_name = module.fedramp_integration_npr_ssm.aws_ssm_document_id
}

output "fedramp_integration_npr_ssm_document_arn" {
  value = module.fedramp_integration_npr_ssm.aws_ssm_document_arn
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
  ssm_document_name = module.fedramp_integration_npri_ssm.aws_ssm_document_id
}

output "fedramp_integration_npri_ssm_document_arn" {
  value = module.fedramp_integration_npri_ssm.aws_ssm_document_arn
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
  ssm_document_name = module.fedramp_integration_prd_ssm.aws_ssm_document_id
}

output "fedramp_integration_prd_ssm_document_arn" {
  value = module.fedramp_integration_prd_ssm.aws_ssm_document_arn
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
  ssm_document_name = module.fedramp_k8s_npr_ssm.aws_ssm_document_id
}

output "fedramp_k8s_npr_ssm_document_arn" {
  value = module.fedramp_k8s_npr_ssm.aws_ssm_document_arn
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
  ssm_document_name = module.fedramp_k8s_npri_ssm.aws_ssm_document_id
}

output "fedramp_k8s_npri_ssm_document_arn" {
  value = module.fedramp_k8s_npri_ssm.aws_ssm_document_arn
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
  ssm_document_name = module.fedramp_k8s_prd_ssm.aws_ssm_document_id
}

output "fedramp_k8s_prd_ssm_document_arn" {
  value = module.fedramp_k8s_prd_ssm.aws_ssm_document_arn
}

output "fedramp_k8s_prd_eb_lambda_arn" {
  value = module.fedramp_k8s_prd_eb_lambda.aws_lambda_function_arn
}

module "fedramp_tools_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_tools
  }
}

module "fedramp_tools_eb_lambda" {
  source = "./modules/eb_lambda"
  providers = {
    aws = aws.fedramp_tools
  }
  ssm_document_name = module.fedramp_tools_ssm.aws_ssm_document_id
}

output "fedramp_tools_ssm_document_arn" {
  value = module.fedramp_tools_ssm.aws_ssm_document_arn
}

output "fedramp_tools_eb_lambda_arn" {
  value = module.fedramp_tools_eb_lambda.aws_lambda_function_arn
}