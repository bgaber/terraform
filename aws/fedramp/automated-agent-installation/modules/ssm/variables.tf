variable "ssm_shared_account_ids" {
  description = "List of AWS account IDs to share the SSM document with"
  type        = list(string)
  default     = [
    "438979369891",
    "491085412189",
    "761018876945",
    "120569617426",
    "686255941416",
    "311141548321",
    "528757785295",
    "054037137415",
    "202533508444",
    "816069130447",
    "445567083790",
    "104299473261",
    "897722679597",
    "195665324256"
  ]
}

variable "penultimate_accounts" {
  description = "List of AWS account IDs that will have the penultimate agent version installed"
  type        = list(string)
  default     = [
    "438979369891",
    "491085412189",
    "761018876945",
    "120569617426",
    "686255941416",
    "311141548321",
    "528757785295",
    "054037137415",
    "202533508444",
    "816069130447",
    "445567083790",
    "104299473261",
    "980921753767",
    "195665324256"
  ]
}

variable "latest_accounts" {
  description = "List of AWS account IDs that will have the latest agent version installed"
  type        = list(string)
  default     = [
    "897722679597"
  ]
}