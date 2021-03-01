variable "credentials_issuer_id" {
  description = "ORY Credentials Issuer ID"
  default = "VXNVcEpFd1p6TGNtTysrNXU4RGJzUT09"
}
variable "namespace" {
  description = "ORY namespace"
  default = "default"
}
variable "hostname" {
  description = "Hostname"
  default = "myambassador.com"
}
variable "protocol" {
  description = "Default protocol (HTTP/HTTPS)"
  default = "http"
}