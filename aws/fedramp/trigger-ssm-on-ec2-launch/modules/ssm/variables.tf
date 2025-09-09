variable "ssm_shared_account_ids" {
  description = "List of AWS account IDs to share the SSM documents with"
  type        = list(string)
  default     = [
    "438979369891",
    "686255941416",
    "311141548321",
    "528757785295",
    "054037137415",
    "202533508444",
    "816069130447",
    "104299473261",
    "445567083790",
    "548813917035",
    "897722679597",
    "195665324256"
  ]
}
