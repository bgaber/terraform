variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "r53_profile" {
  description = "AWS Credential File Profile"
  default     = "US-Test"
  type        = string
}

variable "domain_name" {
  description = "ACM Certificate Domain Name"
  default     = "*.go4connect.com"
  type        = string
}

variable "alternate_names" {
  description = "Subject Alternative Names"
  type        = list(string)
  default = [
    "uat.compucom.go4connect.com",
    "uat.hub.go4connect.com",
    "uat.marc.go4connect.com",
    "uat.usg.go4connect.com",
    "uat.signet.go4connect.com",
    "uat.wts.go4connect.com",
    "uat.sonicdrive.go4connect.com",
    "uat.generali-usa.go4connect.com",
    "uat.pmpediatrics.go4connect.com",
    "uat.epicbrokers.go4connect.com",
    "uat.iiroc.go4connect.com",
    "uat.ciox.go4connect.com",
    "uat.collegiumpharma.go4connect.com",
    "uat.covetrus.go4connect.com",
    "uat.helpathome.go4connect.com",
    "uat.yvr.go4connect.com",
    "uat.camh.go4connect.com",
    "uat.holcim.go4connect.com",
    "uat.fsitportal.go4connect.com",
    "uat.transdevusitportal.go4connect.com"
  ]
}