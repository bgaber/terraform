# variable "keycloak_password_parameters" {
#   description = "List of SSM parameter names for keycloak passwords"
#   type        = list(string)
# }

# variable "keycloak_parameter_sets" {
#   description = "Map of SSM parameter names grouped by customer/env"
#   type = map(object({
#     password = string
#     realm    = string
#     url      = string
#     userid   = string
#     customer = string
#   }))
# }

variable "customers" {
  description = "Map of customer-environment configurations"
  type = map(object({
    url      = string
    realm    = string
    userid   = string
    password = string
    customer = string
  }))
}