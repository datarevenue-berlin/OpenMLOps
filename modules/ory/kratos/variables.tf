variable "namespace" {
  default = "ory"
}
variable "database_name" {
  default = "kratos"
}

variable "db_username" {
  default = "kratos"
}

variable "db_password"{
  default = "secret"
}

variable "domain" {
  default = "http://myambassador.com"
}

variable "cookie-secret" {
  description = "Session Cookie Generation secret"
  default = "VXNVcEpFd1p6TGNtTysrNXU4RGJzUT09"
}

variable "oauth_client_id" {
  description = "oauth2 client id"
  default = "e12a17b54c9b985f60ef"
}

variable "oauth_client_secret" {
  description = "oauth2 client secret"
  default = "d8984b61b593e939accf330be21632dfefe3600e"
}