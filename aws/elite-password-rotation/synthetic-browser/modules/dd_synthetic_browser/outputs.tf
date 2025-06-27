# output "synthetics_test_ids" {
#   value = values(datadog_synthetics_test.elite_password_change)[*].id
# }

# output "synthetics_test_monitor_ids" {
#   value = values(datadog_synthetics_test.elite_password_change)[*].monitor_id
# }

# output "synthetics_test_ids_2" {
#   #value = [ for test_browser in datadog_synthetics_test.elite_password_change : test_browser.id ]
#   value = formatlist("%s-foo", [ for test_browser in datadog_synthetics_test.elite_password_change : test_browser.id ])
# }

# output "synthetics_test_ids_3" {
#   value = {
#     id         = values(datadog_synthetics_test.elite_password_change)[*].id
#     monitor_id = values(datadog_synthetics_test.elite_password_change)[*].monitor_id
#   }
# }



# This is a key-value pair iteration over the resource instances.

# 1. key:

# Represents each unique key from the for_each map.
# In this case, key will be the customer keys: SOM1, SOM2.

# 2. test:

# Represents the resource instance (value) associated with each key.
# The resource object contains all the attributes of a specific datadog_synthetics_test instance. For example:
# resource.id → The unique ID of the synthetic browser test created for the corresponding customer.
# resource.name → The name of the synthetic browser test.

# 3. datadog_synthetics_test.elite_password_change:

# Refers to the entire collection of resources created by the for_each argument.
# Effectively acts like a map where the keys are the customer identifiers (e.g. SOM1, SOM2) and the values are the resource objects.

# output "customers_keycloak_password_ids" {
#   value = { for key, resource in datadog_synthetics_global_variable.keycloak_admin_passwords : key => resource.id }
#   description = "Map of customers and their respective Keycloak Password IDs"
# }

output "customers_new_password_ids" {
  value = { for key, resource in datadog_synthetics_global_variable.new_password_variable : key => resource.id }
  description = "Map of customers and their respective New Password IDs"
}

# output "customers_synthetic_test_ids" {
#   value = { for key, resource in datadog_synthetics_test.elite_password_change : key => resource.id }
#   description = "Map of customers and their respective Datadog Synthetic Test IDs"
# }

# output "customers_synthetic_test_ids_formatted" {
#   value = [for key, resource in datadog_synthetics_test.elite_password_change : "${key} - ${resource.id}"]
#   description = "List of formatted customer keys and their respective Datadog Synthetic Test IDs"
# }


# output "customers_synthetic_test_monitor_ids" {
#   value = { for key, resource in datadog_synthetics_test.elite_password_change : key => resource.monitor_id }
#   description = "Map of customers and their respective Datadog Synthetic Test Monitor IDs"
# }

# output "customers_synthetic_test_monitor_ids_formatted" {
#   value = [for key, resource in datadog_synthetics_test.elite_password_change : "${key} - ${resource.monitor_id}"]
#   description = "List of formatted customer keys and their respective Datadog Synthetic Test Monitor IDs"
# }
