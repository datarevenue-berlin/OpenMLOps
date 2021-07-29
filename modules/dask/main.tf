
resource "helm_release" "dask" {
  name      = "dask"
  namespace = var.namespace

  repository = "https://helm.dask.org"
  chart      = "dask"
  version    = "2021.7.0"

  values = [templatefile("${path.module}/values.yaml", {
    worker_name = var.worker_name
    worker_replicas = var.worker_replicas
    worker_environment_variables = var.worker_environment_variables
    worker_image_repository = var.worker_image_repository
    worker_image_tag = var.worker_image_tag
    worker_image_pull_policy = var.worker_image_pull_policy
    worker_image_pull_secret = var.worker_image_pull_secret
    worker_image_dask_worker_command = var.worker_image_dask_worker_command
    scheduler_image_repository = var.scheduler_image_repository
    scheduler_image_tag = var.scheduler_image_tag
    scheduler_image_pull_policy = var.scheduler_image_pull_policy
  })]
}