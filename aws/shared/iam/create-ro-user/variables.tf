variable "username" {
  type = string
  default = "fudde"
}

variable "fullname" {
  type = string
  default = "Elmer Fudd"
}

variable "accounts" {
  type = list(string)
  #default = ["prod", "test", "dev", "canada"]
  default = ["prod", "test"]
}