variable "tenancy_ocid" {
  description = "Tenancy OCID"
  default     = "ocid1.tenancy.oc1..aaaaaaaaf7vjgacyiqedev3fuwub5qsytgydde7toebfe3tjufkfvl4zgmwa"
  type        = string
}

variable "compartment_ocid" {
  description = "Compartment OCID"
  default     = "ocid1.compartment.oc1..aaaaaaaavr6dl6ev32ykws43mul227eodpqctnb4zykmw5w56dspwhagyvzq"
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
  description = "OCI Machine Image OCID"
  default     = "ocid1.image.oc1.iad.aaaaaaaasdqmcux7p5sdhhsqygmfzf2n6smemihykfv4bv7qh4235zre75da"
  type        = string
}

variable "subnet_ocid" {
  description = "OCI Subnet OCID"
  default     = "ocid1.subnet.oc1.iad.aaaaaaaam5zwjimjeyhj3nyedq4qxyph6xyujhdjqvtrq5j56y2mz2phc44q"
  type        = string
}