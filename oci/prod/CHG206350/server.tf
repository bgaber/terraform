resource "oci_core_instance" "oracle_linux_instance" {
    # Required
    availability_domain = var.availability_domain
    compartment_id      = var.compartment_ocid
    shape               = var.instance_shape
    shape_config {
      memory_in_gbs = var.instance_shape_config_memory_in_gbs
      ocpus         = var.instance_shape_config_ocpus
    }
    source_details {
      boot_volume_size_in_gbs = var.boot_volume_size
      source_id = var.source_ocid
      source_type = "image"
    }

    # Optional
    display_name = var.server_name
    create_vnic_details {
        assign_public_ip = false
        subnet_id        = var.subnet_ocid
    }
    defined_tags = {
      "Application_Metadata.ApplicationOwner" = "Barry Banhagel"
      "Application_Metadata.ApplicationName"  = "Ora_Perspectium"
      "Instance_Metadata.Environment"         = "Prod"
    }
    freeform_tags = {
      "Change"  = "CHG206350"
      "Created" = "23 Aug 2023"
      "Creator" = "Brian Gaber using Terraform"
    }
    metadata = {
        ssh_authorized_keys = file(var.ssh_public_key)
    } 
    preserve_boot_volume = false
}


output "instance-name" {
  value = oci_core_instance.oracle_linux_instance.display_name
}

output "instance-OCID" {
  value = oci_core_instance.oracle_linux_instance.id
}

output "instance-region" {
  value = oci_core_instance.oracle_linux_instance.region
}

output "instance-shape" {
  value = oci_core_instance.oracle_linux_instance.shape
}

output "instance-state" {
  value = oci_core_instance.oracle_linux_instance.state
}

output "instance-OCPUs" {
  value = oci_core_instance.oracle_linux_instance.shape_config[0].ocpus
}

output "instance-memory-in-GBs" {
  value = oci_core_instance.oracle_linux_instance.shape_config[0].memory_in_gbs
}

output "instance-private-ip-address" {
  value = oci_core_instance.oracle_linux_instance.private_ip
}

output "time-created" {
  value = oci_core_instance.oracle_linux_instance.time_created
}