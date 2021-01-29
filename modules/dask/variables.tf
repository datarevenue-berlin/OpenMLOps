variable "namespace" {
  description = "Namespace name to deploy the application"
  default     = "default"
}

variable "worker_name" {
  description = "Dask worker name"
  default     = "worker"
}

variable "worker_replicas" {
  description = "Default number of worker"
  default     = 3
}

variable "worker_image_repository" {
  description = "Container image repository"
  default     = "daskdev/dask"
}

variable "worker_image_tag" {
  description = "Container image tag"
  default     = "2.30.0"
}

variable "worker_image_pull_policy" {
  description = "Container image pull policy."
  default     = "IfNotPresent"
}

variable "worker_image_dask_worker_command" {
  description = "Dask worker command. E.g `dask-cuda-worker` for GPU worker."
  default     = "dask-worker"
}

variable "worker_image_pull_secret" {
  description = "Container image pull secrets"
  type = list(
    object({
      name = string
    })
  )
  default = [{
    name = ""
  }]
}

variable "worker_environment_variables" {
  description = "Environment variables. See `values.yaml` for example values."
  type = list(object({
    name  = string
    value = string
  }))

  default = [
    {
      name  = "EXTRA_CONDA_PACKAGES"
      value = ""
    },
    {
      name  = "EXTRA_PIP_PACKAGES"
      value = ""
    }
  ]
}