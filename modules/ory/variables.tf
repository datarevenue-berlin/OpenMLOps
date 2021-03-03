variable "credentials_issuer_id" {
  # TODO: Remove default
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

variable "db_password"{
  description = "PostgreSQL Database Password"
}

variable "cookie-secret" {
  description = "Session Cookie Generation secret"
  sensitive = true
}

variable "oauth2_providers" {
  //  Configure multiple Oauth2 providers.
  //  example:
  //  [{
  //    provider = github
  //    client_id = change_me
  //    client_secret = change_me
  //    tenant = null
  //  }]
  //  If you're using GitHub, Google or Facebook, tenant won't be needed, so please set
  //  it as null or an empty string. It is required for AzureAd
  type = list(object({
    provider = string
    client_id = string
    client_secret = string
    tenant = string
  }))
  description = "OAuth2 Providers credentials"
}
