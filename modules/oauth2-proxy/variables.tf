
variable "oauth_client_id" {
  description = "OAuth 2 Client ID"
}
variable "oauth_client_secret" {
  description = "OAuth 2 Client Secret"
}
variable "oauth_provider" {
  description = "OAuth 2 Provider"
}
variable "redirect_url" {
  description = "OAuth 2 Redirect URL"
}
variable "domain" {
  description = "Application domain"
}

# OAuth2_proxy configuration
variable "oauth_helm_chart_version" {
  description = "OAuth 2.0 Helm Chart Version"
  default     = "4.3.0"
}
variable "oauth_image_repository" {
  default     = "quay.io/pusher/oauth2_proxy"
  description = "image repository of oauth2 proxy"
}
variable "oauth_image_tag" {
  default     = "v5.1.0"
  description = "image tag of oauth2 proxy"
}
# OAuth2_proxy cookie configuration
variable "oauth_cookie_expire" {
  default     = "3600"
  description = "TTL for issuing cookies by oauth2_proxy"
}
variable "oauth_cookie_secret" {
  description = "Secret for issuing cookies by oauth2_proxy"
}

variable "namespace" {
  description = "Namespace name to deploy the application"
  default     = "default"
}