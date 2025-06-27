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