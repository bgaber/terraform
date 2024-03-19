terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# provider "oci" {
#   tenancy_ocid = var.tenancy_ocid
#   config_file_profile= var.config_file_profile
# }

data "oci_identity_compartment" "test_compartment" {
    #Required
    id = var.compartment_id
}

output "parent_compartment" {
  value = data.oci_identity_compartment.test_compartment.compartment_id
}

output "compartment_description" {
  value = data.oci_identity_compartment.test_compartment.description
}

output "compartment_id" {
  value = data.oci_identity_compartment.test_compartment.id
}

output "compartment_name" {
  value = data.oci_identity_compartment.test_compartment.name
}

output "compartment_state" {
  value = data.oci_identity_compartment.test_compartment.state
}