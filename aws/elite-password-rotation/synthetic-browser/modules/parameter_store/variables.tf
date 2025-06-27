variable "parameters" {
  description = "Map of Parameter Store key/value pairs"
  type        = map(string)
  default     = {}  # Optional but recommended for flexibility
}