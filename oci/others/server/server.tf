terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
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

resource "oci_core_instance" "ubuntu_instance" {
    # Required
    availability_domain = var.availability_domain
    compartment_id = var.compartment_ocid
    shape = "VM.Standard2.1"
    source_details {
        source_id = var.source_ocid
        source_type = "image"
    }

    # Optional
    display_name = "Demo OCI Server"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = var.subnet_ocid
    }
    # metadata = {
    #     ssh_authorized_keys = file("<ssh-public-key-path>")
    # } 
    preserve_boot_volume = false
}


output "instance-name" {
  value = oci_core_instance.ubuntu_instance.display_name
}

output "instance-OCID" {
  value = oci_core_instance.ubuntu_instance.id
}

output "instance-region" {
  value = oci_core_instance.ubuntu_instance.region
}

output "instance-shape" {
  value = oci_core_instance.ubuntu_instance.shape
}

output "instance-state" {
  value = oci_core_instance.ubuntu_instance.state
}

output "instance-OCPUs" {
  value = oci_core_instance.ubuntu_instance.shape_config[0].ocpus
}

output "instance-memory-in-GBs" {
  value = oci_core_instance.ubuntu_instance.shape_config[0].memory_in_gbs
}

output "time-created" {
  value = oci_core_instance.ubuntu_instance.time_created
}