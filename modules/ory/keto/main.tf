locals {
  db_host = "postgres-keto-postgresql.${helm_release.keto-postgres.namespace}.svc.cluster.local"
  dsn = "postgres://${var.db_username}:${urlencode(var.db_password)}@${local.db_host}:5432/${var.database_name}"
}


resource "helm_release" "ory-keto" {
  name = "ory-keto"
  namespace = var.namespace
  repository = "https://k8s.ory.sh/helm/charts"
  chart = "keto"
  depends_on = [
    helm_release.keto-postgres]

  values = [
    templatefile("${path.module}/values.yaml", {
      dsn = local.dsn
    })
  ]
}


resource "helm_release" "keto-postgres" {
  name      = "postgres-keto"
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
}
