variable "namespace" {
  description = "Namespace name to deploy the application"
  default     = "default"
}

variable "dask_name" {
  description = "Dask release name"
  default     = "dask"
}

variable "hub_allowed_named_servers" {
  description = "Configures if a user can spawn multiple servers"
  default     = false
}

variable "authentication_type" {
  description = "Configures the authentication type. Default dummy."
  default     = "DummyAuthenticator"
}

variable "authentication_config" {
  description = "configure JupyterHub to use our chosen authenticator class and the authenticator class"
  default = {
    DummyAuthenticator = {
      password = "a-shared-secret-password"
    }
    JupyterHub = {
      authenticator_class = "dummy"
    }
  }

}

variable "proxy_https_enabled" {
  description = "Indicator to set whether HTTPS should be enabled or not on the proxy"
  default     = false
}

variable "proxy_secret_token" {
  description = "A 32-byte cryptographically secure randomly generated string used to secure communications between the hub and the configurable-http-proxy"
  default = null
}

variable "proxy_https_hosts" {
  description = "You domains in list form. Required for automatic HTTPS"
  default     = null
}

variable "proxy_https_letsencrypt_contact_email" {
  description = "The contact email to be used for automatically provisioned HTTPS certificates by Let’s Encrypt"
  default     = ""
}


variable "singleuser_image_pull_secrets" {
  type = list(
    object({
      name = string
    })
  )
  default = []
}

variable "singleuser_image_pull_policy" {
  default = "Always"
}

variable "singleuser_default_url" {
  description = ""
  default     = "/lab"
}

variable "singleuser_profile_list" {
  description = "List of images which the user can select to spawn a server"
  type = list(object({
    display_name = string
    description  = string
    default      = bool
    kubespawner_override = object({
      image = string
    })
  }))

  default = [
    {
      display_name = "Datascience environment"
      description  = "Default data science enviroment"
      default      = true
      kubespawner_override = {
        image = "jupyter/datascience-notebook:2343e33dec46"
      }

    }
  ]

}

variable "singleuser_memory_guarantee" {
  default = "1G"
}

variable "singleuser_storage_capacity" {
  default = "1G"
}

variable "singleuser_storage_mount_path" {
  default = "/home/jovyan/persistent"
}

