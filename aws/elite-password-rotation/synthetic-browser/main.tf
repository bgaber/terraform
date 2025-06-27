module "iam_service_account" {
  source = "./modules/iam_service_account"
}

output "service_account_id" {
  value = module.iam_service_account.service_account_id
}

output "service_account_arn" {
  value = module.iam_service_account.service_account_arn
}

output "service_account_name" {
  value = module.iam_service_account.service_account_name
}

output "service_secret_id" {
  value = module.iam_service_account.service_secret_id
}

output "service_secret_access_key" {
  value = module.iam_service_account.service_secret_access_key
  sensitive = true
}

module "parameter_store" {
  source = "./modules/parameter_store"
  parameters = var.parameters
}

output "all_parameters" {
  value = module.parameter_store.ssm_parameters
}

# Transform flat map of strings into a grouped map of customer-env -> { password, realm, url, userid }
locals {
  # Step 1: Flatten parameters to tuples of [group_key, key_in_object, value]
  parameter_tuples = [
    for full_key, value in var.parameters : {
      group_key = join("_", slice(split("/", full_key), 1, 3))     # e.g. customer1_prod
      key       = split("/", full_key)[4]                          # e.g. password
      value     = value
    }
  ]

  # Step 2: Group by environment and assemble objects with customer field
  customers = {
    for group_key in distinct([for p in local.parameter_tuples : p.group_key]) :
    group_key => merge(
      {
        customer = split("_", group_key)[0]
      },
      merge([
        for p in local.parameter_tuples : {
          for inner in [p] :
          inner.key => inner.value
        } if p.group_key == group_key
      ]...)
    )
  }
}

output "all_customers" {
  value = local.customers
}

module "dd_synthetic_browser" {
  source = "./modules/dd_synthetic_browser"
  customers = local.customers
}