resource "aws_iam_role" "ssm_assume_role" {
  name = "crowdstrike-distributor-deploy-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ssm.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachments_exclusive" "ssm_assume_role" {
  role_name   = aws_iam_role.ssm_assume_role.name
  policy_arns = lower(var.secret_storage_method) == "secretsmanager" ? [
    "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    ] : [
    "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole",
  ]
}

resource "time_sleep" "ssm_assume_role" {
  triggers = {
    ssm_assume_role_arn = aws_iam_role.ssm_assume_role.arn
  }
  create_duration = "10s"
}


module "fedramp_agencysim_npri_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_agencysim_npri
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_edge_nw_npr_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_edge_nw_npr
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_edge_nw_npri_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_edge_nw_npri
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_edge_nw_prd_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_edge_nw_prd
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_integration_npr_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_integration_npr
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_integration_npri_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_integration_npri
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_integration_prd_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_integration_prd
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_k8s_npr_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_k8s_npr
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_k8s_npri_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_k8s_npri
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_k8s_prd_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_k8s_prd
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_network_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_network
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_network_prd_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_network_prd
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_security_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_security
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_tools_npri_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_tools_npri
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}

module "fedramp_tools_prd_crowdstrike_distributor" {
  source = "./modules/crowdstrike-distributor"
  providers = {
    aws = aws.fedramp_tools_prd
  }

  ssm_assume_role_arn = time_sleep.ssm_assume_role.triggers["ssm_assume_role_arn"]
  linux_package_version = var.linux_package_version
  windows_package_version = var.windows_package_version
  linux_installer_params = var.linux_installer_params
  windows_installer_params = var.windows_installer_params
  cron_schedule_expression = var.cron_schedule_expression

  falcon_client_id = var.falcon_client_id
  falcon_client_secret = var.falcon_client_secret
  falcon_cloud = var.falcon_cloud

  secret_storage_method = var.secret_storage_method
  secrets_manager_secret_name = var.secrets_manager_secret_name
  falcon_cloud_ssm_parameter_name = var.falcon_cloud_ssm_parameter_name
  falcon_client_id_ssm_parameter_name = var.falcon_client_id_ssm_parameter_name
  falcon_client_secret_ssm_parameter_name = var.falcon_client_secret_ssm_parameter_name

  depends_on = [
    aws_iam_role.ssm_assume_role
  ]
}