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

variable "access_rules" {
  description = "Access rules"
  type=list(object({
    id=string
    match=object({
      url = string
      methods = list(string)
    })
    authenticators = list(object({
      handler = string
    }))
    authorizer=object({
      handler=string
    })
    mutators = list(object({
      handler = string
    }))
    credential_issuer=object({
      handler=string
    })
  }))
}

variable "enable_registration" {
  description = "Bool to set if registration page will or not be visible to users"
  type = bool
}

variable "access_rules_path" {
    type = string
    default = null
}
