resource "kubernetes_secret" "private_registry_secret" {
  count = var.docker_private_repo ? 1 : 0
  metadata {
    name      = "regcred"
    namespace = var.namespace
  }
  data = {
    ".dockerconfigjson" = <<-DOCKER
          {
            "auths": {
              "${var.docker_registry_server}": {
                "auth": "${var.docker_auth_key}"
              }
            }
          }
          DOCKER
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "helm_release" "mlflow" {
  name       = "mlflow"
  namespace  = var.namespace
  version    = "1.0.1"
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

  set {
    name = "service.type"
    value = var.service_type
  }

  values = [
    yamlencode({
      imagePullSecrets = (var.docker_private_repo == true ? [{
        name = kubernetes_secret.private_registry_secret[0].metadata[0].name
      }] : [])
    }),
  ]
}
