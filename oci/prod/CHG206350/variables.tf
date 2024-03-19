variable "tenancy_ocid" {
  description = "Tenancy OCID"
  default     = "ocid1.tenancy.oc1..aaaaaaaaf7vjgacyiqedev3fuwub5qsytgydde7toebfe3tjufkfvl4zgmwa"
  type        = string
}

variable "compartment_ocid" {
  description = "PROD_APP Compartment OCID"
  default     = "ocid1.compartment.oc1..aaaaaaaat7albusvth4yiqhssjuntth75gsljk2cubegkdcw226cblkubmua"
  type        = string
}

variable "config_file_profile" {
  description = "OCI CLI Config file"
  default     = "/root/.oci/config"
  type        = string  
}

variable "user_ocid" {
  description = "User OCID"
  default     = "ocid1.user.oc1..aaaaaaaa4np7mqbee2nxlwjl7poyzfk4yh5cr2u7cmntm2f2547ogizgwpjq"
  type        = string
}

variable "fingerprint" {
  description = "User Fingerprint"
  default     = "37:b4:3a:63:5c:fc:6a:75:a1:f4:af:81:a9:d4:e0:59"
  type        = string
}

variable "private_key_path" {
  description = "User Key Path"
  default     = "/home/awsadmin/bg216063/APIAdmin_2023-06-08T11_48_41.321Z.pem"
  type        = string
}

variable "region" {
  description = "OCI Region"
  default     = "us-ashburn-1"
  type        = string
}

variable "availability_domain" {
  description = "OCI Availability Domain"
  default     = "oEiO:US-ASHBURN-AD-1"
  type        = string
}

variable "source_ocid" {
  description = "Oracle-Linux-8.8-2023.08.16-0 for x86_64 OCID"
  default     = "ocid1.image.oc1.iad.aaaaaaaaj3fbxkn7ql2l4zvdio7atzczezg6dv5dncmz247wfoaqgfgyagaq"
  type        = string
}

variable "subnet_ocid" {
  description = "PROD_APP_PVT_SN Subnet OCID"
  default     = "ocid1.subnet.oc1.iad.aaaaaaaakwj52i3y4xavnuoey6in5qpgdfdx7pllvmo4ft6lknooobyvksga"
  type        = string
}

variable "server_name" {
  description = "Server Name"
  default     = "pocioraper02"
  type        = string
}

variable "boot_volume_size" {
  description = "Boot Volume Size in GigaBytes"
  default     = "200"
  type        = string
}

variable "instance_shape" {
  description = "Instance Shape"
  default     = "VM.Standard.E4.Flex"
  type        = string
}

variable "instance_shape_config_memory_in_gbs" {
  description = "Memory in GigaBytes"
  default     = "32"
  type        = string
}

variable "instance_shape_config_ocpus" {
  description = "Number of OCPUs"
  default     = "4"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH Public Key"
  default     = "/home/awsadmin/bg216063/oci-ssh-keys/prod-ssh-key.pub"
  type        = string
}