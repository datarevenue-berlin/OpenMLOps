variable "namespace" {
  default = "ory"
  type = string
}
variable "hostname" {
  description = "Hostname"
}

variable "database_name" {
  default = "keto"
  description = "PostgreSQL Database Name"
  type = string
}

variable "db_username" {
  default = "keto"
  description = "PostgreSQL Database Username"
  type = string
}

variable "db_password"{
  description = "PostgreSQL Database Password"
  type = string
}