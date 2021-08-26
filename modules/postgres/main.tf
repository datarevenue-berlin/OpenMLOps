
resource "helm_release" "postgres" {
  name      = "postgres"
  namespace = var.namespace
  version = "10.9.1"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"

  set {
    name  = "postgresqlUsername"
    value = var.db_username
  }

  set {
    name  = "postgresqlPassword"
    value = var.db_password
  }

  set {
    name  = "postgresqlDatabase"
    value = var.database_name
  }

  set {
    name  = "service.port"
    value = var.service_port
  }

  set {
    name = "image.tag"
    value = "11.12.0-debian-10-r70"
  }
}