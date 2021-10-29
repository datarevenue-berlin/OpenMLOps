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

variable "configuration_overrides" {
  description="Additional overrides should follow the config structure as specified here: https://www.ory.sh/oathkeeper/docs/reference/configuration/"
  default={}
}

variable "enable_registration" {
  description = "Bool to set if registration page will or not be visible to users"
  type = bool
}

variable "access_rules_path" {
    type = string
    default = null
}
