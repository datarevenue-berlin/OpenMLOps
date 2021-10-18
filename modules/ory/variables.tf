// ORY
variable "namespace" {
  description = "ORY namespace"
  default = "default"
}
variable "hostname" {
  description = "Hostname"
}
variable "protocol" {
  description = "Default protocol (HTTP/HTTPS)"
  default = "http"
}

// KRATOS
variable "kratos_db_password"{
  description = "PostgreSQL Database Password"
}

variable "cookie_secret" {
  description = "Session Cookie Generation secret"
  sensitive = true
}

variable "enable_registration" {
  description = "Bool to set if registration page will or not be visible to users"
  type = bool
}

variable "smtp_connection_uri" {
  description = "SMTP Connection for Ory"
  type = string
}

variable "smtp_from_address" {
  description = "Email address for outgoing mails from Ory"
  type = string
}

variable "enable_password_recovery" {
  description = "Bool to set to enable password recovery using emails"
  type = bool
}

variable "enable_verification" {
  description = "Bool to set to enable account registration confirmation using emails"
  type = bool
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

variable "access_rules_path" {
  type = string
  default = null
}

variable "kratos_chart_values_path" {
  description = "Path to custom values.yaml for Kratos"
  type = string
  default = null
}

variable "kratos_cors_enabled_url" {
  description = "The URL that needs to be set as origin for CORS to work between UI/Frontend and Kratos backend."
  type = string
}