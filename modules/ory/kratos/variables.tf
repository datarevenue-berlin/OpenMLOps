variable "namespace" {
  default = "ory"
}

variable "database_name" {
  default = "kratos"
  description = "PostgreSQL Database Name"
}

variable "db_username" {
  default = "kratos"
  description = "PostgreSQL Database Username"
}

variable "db_password"{
  description = "PostgreSQL Database Password"
}

variable "domain" {
  description = "Your application domain"
  default = "http://myambassador.com"
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
    tentant = string
  }))
  description = "OAuth2 Providers credentials"
}

//variable "github_oauth" {
//  description = "Accept GitHub as OAuth2 Provider"
//  default = true
//  type = bool
//}
//variable "github_oauth_credentials" {
//  description = "Oauth2 Client ID used for GitHub"
//  default = ""
//  sensitive = true
//  type = object({})
//}
//
//variable "github_client_secret" {
//  description = "Oauth2 Client Secret used for Github"
//  default = ""
//  sensitive = true
//}