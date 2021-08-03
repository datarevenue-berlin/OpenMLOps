variable "namespace" {
  description = "Namespace name to deploy the application"
  default     = "default"
}

variable "jupyterhub_secret" {
    type = string
    default = "4301bf5a2aa1fbade157046863ac64ec46df03e3da39ec3bf345a2f8caa81e02"
}

variable "daskgateway_secret" {
    type = string
    default = "ca7de235a4ae54103d49f5004a11690004c66fe14810f35dc476103573e56ff1"
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
  type = list(
    object({
      display_name = string
      description  = string
      default      = bool
      kubespawner_override = object({
        image = string
      })
  }))

  default = [{
      display_name = "OpenMLOps client environment"
      description  = "Notebook with OpenMLOps required client libraries installed. <br> Image: drtools/openmlops-notebook:v1.4"
      default      = true
      kubespawner_override = {
        image = "drtools/openmlops-notebook:v1.4"
      }
  }]
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

variable "hub_allow_named_servers" {
  description = "Configures if a user can spawn multiple servers"
  default     = false
}