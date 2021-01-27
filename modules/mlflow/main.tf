
resource "helm_release" "mlflow" {
  name      = "mlflow"
  namespace = var.namespace

  repository = "https://larribas.me/helm-charts"
  chart      = "mlflow"

  set {
    name  = "backendStore.postgres.username"
    value = var.db_username
  }

  set {
    name  = "backendStore.postgres.password"
    value = var.db_password
  }

  set {
    name  = "backendStore.postgres.database"
    value = var.database_name
  }

  set {
    name  = "backendStore.postgres.host"
    value = var.db_host
  }

  set {
    name  = "backendStore.postgres.port"
    value = var.db_port
  }

  set {
    name  = "defaultArtifactRoot"
    value = var.default_artifact_root
  }

  set {
    name  = "image.repository"
    value = var.image_repository
  }

  set {
    name  = "image.pullPolicy"
    value = var.image_pull_policy
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

}