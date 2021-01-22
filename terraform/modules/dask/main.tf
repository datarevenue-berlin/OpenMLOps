provider "helm" {}


resource "helm_release" "dask" {
  name      = "dask"
  namespace = var.namespace

  repository = "https://helm.dask.org"
  chart      = "dask"
  version    = "4.5.6"

  set {
    name  = "worker.name"
    value = var.worker_name
  }

  set {
    name  = "worker.replicas"
    value = var.worker_replicas
  }

  set {
    name  = "worker.image.repository"
    value = var.worker_image_repository
  }

  set {
    name  = "worker.image.tag"
    value = var.worker_image_tag
  }

  set {
    name  = "worker.image.pullPolicy"
    value = var.worker_image_pull_policy
  }

  set {
    name  = "worker.image.dask_worker"
    value = var.worker_image_dask_worker_command
  }

  set {
    name  = "worker.image.pullSecrets"
    value = yamlencode(var.worker_image_pull_secret)
  }

  set {
    name  = "worker.env"
    value = yamlencode(var.worker_environment_variables)
  }

}