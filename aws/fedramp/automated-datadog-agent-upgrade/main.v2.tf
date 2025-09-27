module "fedramp_security_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_security
  }
}

module "fedramp_security_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_security
  }
}

module "fedramp_security_eb_lambda" {
  linux_ssm_document_name     = module.fedramp_security_ssm.linux_ssm_document_id
  windows_ssm_document_name   = module.fedramp_security_ssm.windows_ssm_document_id
  sns_topic_arn               = module.fedramp_security_sns.sns_topic_arn
  lambda_role_name            = var.lambda_role_name
  lambda_policy_name          = var.lambda_policy_name
  lambda_iam_assume_role_name = var.lambda_iam_assume_role_name
  source = "./modules/eb-lambda"
  providers = {
    aws = aws.fedramp_security
  }
}

# Do not need IAM Assume Role in the Lambda account
#
# module "fedramp_security_iam_role" {
#   source = "./modules/lambda-iam-assume-role"
#   lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
#   lambda_assume_role = var.lambda_role_name
#   lambda_policy      = var.lambda_policy_name
#   providers = {
#     aws = aws.fedramp_security
#   }
# }

module "fedramp_agencysim_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
}

module "fedramp_agencysim_npri_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
}

module "fedramp_agencysim_npri_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_agencysim_npri
  }
}

module "fedramp_edgenw_npr_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_edge_nw_npr
  }
}

module "fedramp_edgenw_npr_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_edge_nw_npr
  }
}

module "fedramp_edgenw_npr_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_edge_nw_npr
  }
}

module "fedramp_edgenw_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_edge_nw_npri
  }
}

module "fedramp_edgenw_npri_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_edge_nw_npri
  }
}

module "fedramp_edgenw_npri_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_edge_nw_npri
  }
}

module "fedramp_edgenw_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_edge_nw_prd
  }
}

module "fedramp_edgenw_prd_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_edge_nw_prd
  }
}

module "fedramp_edgenw_prd_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_edge_nw_prd
  }
}

module "fedramp_integration_npr_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_integration_npr
  }
}

module "fedramp_integration_npr_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_integration_npr
  }
}

module "fedramp_integration_npr_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_integration_npr
  }
}

module "fedramp_integration_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_integration_npri
  }
}

module "fedramp_integration_npri_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_integration_npri
  }
}

module "fedramp_integration_npri_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_integration_npri
  }
}

module "fedramp_integration_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_integration_prd
  }
}

module "fedramp_integration_prd_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_integration_prd
  }
}

module "fedramp_integration_prd_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_integration_prd
  }
}

module "fedramp_k8s_npr_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

module "fedramp_k8s_npr_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

module "fedramp_k8s_npr_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_k8s_npr
  }
}

module "fedramp_k8s_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

module "fedramp_k8s_npri_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

module "fedramp_k8s_npri_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_k8s_npri
  }
}

module "fedramp_k8s_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

module "fedramp_k8s_prd_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

module "fedramp_k8s_prd_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_k8s_prd
  }
}

module "fedramp_network_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_network
  }
}

module "fedramp_network_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_network
  }
}

module "fedramp_network_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_network
  }
}

module "fedramp_tools_npri_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_tools_npri
  }
}

module "fedramp_tools_npri_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_tools_npri
  }
}

module "fedramp_tools_npri_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_tools_npri
  }
}

module "fedramp_tools_prd_ssm" {
  source = "./modules/ssm"
  providers = {
    aws = aws.fedramp_tools_prd
  }
}

module "fedramp_tools_prd_sns" {
  source = "./modules/sns"
  providers = {
    aws = aws.fedramp_tools_prd
  }
}

module "fedramp_tools_prd_iam_role" {
  source = "./modules/lambda-iam-assume-role"
  lambda_role_arn    = "arn:aws:iam::${var.lambda_account}:role/${var.lambda_role_name}" ## ARN from FedRAMP Security account
  lambda_assume_role = var.lambda_iam_assume_role_name
  lambda_policy      = var.lambda_iam_assume_role_policy_name
  providers = {
    aws = aws.fedramp_tools_prd
  }
}

output "fedramp_security_linux_ssm_document_arn" {
  value = module.fedramp_security_ssm.linux_ssm_document_arn
}

output "fedramp_security_windows_ssm_document_arn" {
  value = module.fedramp_security_ssm.windows_ssm_document_arn
}

output "fedramp_security_lambda_function_arn" {
  value = module.fedramp_security_eb_lambda.aws_lambda_function_arn
}

output "fedramp_security_lambda_function_invoke_arn" {
  value = module.fedramp_security_eb_lambda.aws_lambda_function_invoke_arn
}

output "fedramp_security_sns_topic_arn" {
  value = module.fedramp_security_sns.sns_topic_arn
}

output "fedramp_security_sns_subsctiption_arn" {
  value = module.fedramp_security_sns.sns_subscription_arn
}

output "fedramp_security_scheduler_schedule_id" {
  value = module.fedramp_security_eb_lambda.aws_scheduler_schedule_id
}

output "fedramp_security_scheduler_schedule_arn" {
  value = module.fedramp_security_eb_lambda.aws_scheduler_schedule_arn
}
