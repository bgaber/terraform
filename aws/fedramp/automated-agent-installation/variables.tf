variable "fedramp_agencysim_npri_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-agencysim-npri"
  type        = string
}

variable "fedramp_edge_nw_npr_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-edge-nw-npr"
  type        = string
}

variable "fedramp_edge_nw_npri_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-edge-nw-npri"
  type        = string
}

variable "fedramp_edge_nw_prd_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-edge-nw-prd"
  type        = string
}

variable "fedramp_integration_npr_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-integration-npr"
  type        = string
}

variable "fedramp_integration_npri_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-integration-npri"
  type        = string
}

variable "fedramp_integration_prd_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-integration-prd"
  type        = string
}

variable "fedramp_k8s_npr_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-k8s-npr"
  type        = string
}

variable "fedramp_k8s_npri_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-k8s-npri"
  type        = string
}

variable "fedramp_k8s_prd_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-k8s-prd"
  type        = string
}

variable "fedramp_network_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-network"
  type        = string
}

variable "fedramp_security_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-security"
  type        = string
}

variable "fedramp_tools_npri_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-tools-npri"
  type        = string
}

variable "fedramp_tools_prd_profile" {
  description = "AWS Credential File Profile"
  default     = "fedramp-tools-prd"
  type        = string
}

variable "lambda_role_name" {
  description = "FedRAMP Lambda IAM Role"
  default     = "FedRAMPLambdaIAMRole"
  type        = string
}

variable "lambda_policy_name" {
  description = "FedRAMP Lambda IAM Policy"
  default     = "FedRAMPLambdaIAMPolicy"
  type        = string
}

variable "lambda_account" {
  description = "The AWS account from which the Lambda function runs"
  default     = "980921753767"
  type        = string
}

variable "lambda_iam_assume_role_name" {
  description = "The IAM Role that is assumed by the Lambda function in other accounts"
  default     = "FedRAMPSSMExecutionRole"
  type        = string
}

variable "lambda_iam_assume_role_policy_name" {
  description = "The IAM Policy that is assumed by the Lambda function in other accounts"
  default     = "FedRAMPSSMExecutionPolicy"
  type        = string
}