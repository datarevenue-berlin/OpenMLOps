variable "namespace" {
  default = "ory"
  type = string
}

variable "database_name" {
  default = "kratos"
  description = "PostgreSQL Database Name"
  type = string
}

variable "db_username" {
  default = "kratos"
  description = "PostgreSQL Database Username"
  type = string
}

variable "db_password"{
  description = "PostgreSQL Database Password"
  type = string
}

variable "app_url" {
  description = "Your application URL. Ex.: http://my-mlops.com"
  type = string
}

variable "cookie_secret" {
  description = "Session Cookie Generation secret"
  sensitive = true
  type = string
}

variable "cookie_domain" {
  description = "Sets the session cookie domain. Useful when dealing with subdomains. Use with care! If blank, only requests strictly from the exactly same domain (no subdomains) will be accepted "
  type = string
  default = ""
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
