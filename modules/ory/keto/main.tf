locals {
  dsn = "postgres://${var.db_username}:${urlencode(var.db_password)}@${module.keto-postgres.db_host}:5432/${var.database_name}"
}

resource "helm_release" "ory-keto" {
  name = "ory-keto"
  namespace = var.namespace
  repository = "https://k8s.ory.sh/helm/charts"
  chart = "keto"
  depends_on = [
    module.keto-postgres]

  values = [
    templatefile("${path.module}/values.yaml", {
      dsn = local.dsn
    })
  ]
}

module "keto-postgres" {
  source = "../../postgres"
  namespace = var.namespace

  database_name = var.database_name
  db_username = var.db_username
  db_password = var.db_password
}
output "db_connection_string" {
  value = local.dsn
}