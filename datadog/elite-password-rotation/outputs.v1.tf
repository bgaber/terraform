# output "synthetics_test_ids" {
#   value = values(datadog_synthetics_test.elite_test_browser)[*].id
# }

# output "synthetics_test_monitor_ids" {
#   value = values(datadog_synthetics_test.elite_test_browser)[*].monitor_id
# }

# output "synthetics_test_ids_2" {
#   #value = [ for test_browser in datadog_synthetics_test.elite_test_browser : test_browser.id ]
#   value = formatlist("%s-foo", [ for test_browser in datadog_synthetics_test.elite_test_browser : test_browser.id ])
# }

# output "synthetics_test_ids_3" {
#   value = {
#     id         = values(datadog_synthetics_test.elite_test_browser)[*].id
#     monitor_id = values(datadog_synthetics_test.elite_test_browser)[*].monitor_id
#   }
# }



# This is a key-value pair iteration over the resource instances.

# 1. key:

# Represents each unique key from the for_each map.
# In this case, key will be the customer keys: SOM1, SOM2.

# 2. test:

# Represents the resource instance (value) associated with each key.
# The test object contains all the attributes of a specific datadog_synthetics_test instance. For example:
# test.id → The unique ID of the synthetic test created for the corresponding customer.
# test.name → The name of the synthetic test.

# 3. datadog_synthetics_test.elite_test_browser:

# Refers to the entire collection of resources created by the for_each argument.
# Effectively acts like a map where the keys are the customer identifiers (SOM1, SOM2) and the values are the resource objects.

output "customers_synthetic_test_ids" {
  value = { for key, test in datadog_synthetics_test.elite_test_browser : key => test.id }
  description = "Map of customers and their respective Datadog Synthetic Test IDs"
}

output "customers_synthetic_test_ids_formatted" {
  value = [for key, test in datadog_synthetics_test.elite_test_browser : "${key} - ${test.id}"]
  description = "List of formatted customer keys and their respective Datadog Synthetic Test IDs"
}


output "customers_synthetic_test_monitor_ids" {
  value = { for key, test in datadog_synthetics_test.elite_test_browser : key => test.monitor_id }
  description = "Map of customers and their respective Datadog Synthetic Test Monitor IDs"
}

output "customers_synthetic_test_monitor_ids_formatted" {
  value = [for key, test in datadog_synthetics_test.elite_test_browser : "${key} - ${test.monitor_id}"]
  description = "List of formatted customer keys and their respective Datadog Synthetic Test Monitor IDs"
}

