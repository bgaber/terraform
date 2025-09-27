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

module "dd_synthetic_browser" {
  source = "./modules/dd_synthetic_browser"

  keycloak_password_parameters = [
    for k, v in module.parameter_store.ssm_parameters : k if can(regex("/password$", k))
  ]

  # keycloak_parameter_sets = {
  #   for name, param in module.parameter_store.ssm_parameters :
  #   join("/", slice(split("/", name), 0, 3)) => merge(
  #     {
  #       "customer" = split("/", name)[1]
  #     },
  #     lookup(
  #       {
  #         "password" = {}
  #         "realm"    = {}
  #         "url"      = {}
  #         "userid"   = {}
  #       },
  #       split("/", name)[3],
  #       {}
  #     ),
  #     {
  #       split("/", name)[3] = param
  #     }
  #   )
  # }

  # keycloak_parameter_sets = {
  #   for full_key, param in module.parameter_store.ssm_parameters :
  #   join("/", slice(split(full_key, "/"), 0, 3)) => {
  #     customer = split(full_key, "/")[1]
  #     password = try(module.parameter_store.ssm_parameters["${join("/", slice(split(full_key, "/"), 0, 4))}/password"], null)
  #     realm    = try(module.parameter_store.ssm_parameters["${join("/", slice(split(full_key, "/"), 0, 4))}/realm"], null)
  #     url      = try(module.parameter_store.ssm_parameters["${join("/", slice(split(full_key, "/"), 0, 4))}/url"], null)
  #     userid   = try(module.parameter_store.ssm_parameters["${join("/", slice(split(full_key, "/"), 0, 4))}/userid"], null)
  #   }
  #   if endswith(full_key, "/password")  # only evaluate each group once
  # }

  # Transform flat map into customer-environment structure
  customers = {
    for key, value in var.parameters : 
    "${split("/", key)[1]}-${split("/", key)[2]}" => {
      "customer" = split("/", key)[1],
      "url"      = var.parameters["/${split("/", key)[1]}/${split("/", key)[2]}/keycloak/url"],
      "realm"    = var.parameters["/${split("/", key)[1]}/${split("/", key)[2]}/keycloak/realm"],
      "userid"   = var.parameters["/${split("/", key)[1]}/${split("/", key)[2]}/keycloak/userid"],
      "password" = var.parameters["/${split("/", key)[1]}/${split("/", key)[2]}/keycloak/password"]
    } if length(split("/", key)) == 5 && contains(["url", "realm", "userid", "password"], split("/", key)[4])
  }
}