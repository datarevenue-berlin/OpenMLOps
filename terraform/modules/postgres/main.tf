provider "helm" {}

resource "helm_release" "postgres" {
  name      = "postgres"
  namespace = var.namespace

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

}