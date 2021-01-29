
resource "kubernetes_secret" "feast_postgresql_secret" {
  metadata {
    name      = "feast-postgresql"
    namespace = var.namespace
  }
  data = {
    postgresql-password = var.feast_postgresql_password
  }
}


resource "helm_release" "feast" {
  name      = "feast"
  namespace = var.namespace

  repository = "https://feast-charts.storage.googleapis.com"
  chart      = "feast"
  version    = "0.8.2"


  set {
    name  = "feast-core.enabled"
    value = var.feast_core_enabled
  }

  set {
    name  = "feast-core.postgresql.existingSecret"
    value = kubernetes_secret.feast_postgresql_secret.metadata[0].name
  }

  set {
    name  = "feast-online-serving.enabled"
    value = var.feast_online_serving_enabled
  }

  set {
    name  = "feast-jupyter.enabled"
    value = var.feast_jupyter_enabled
  }

  set {
    name  = "feast-jobservice.enabled"
    value = var.feast_jobservice_enabled
  }

  set {
    name  = "feast-jobservice.enabled"
    value = var.feast_jobservice_enabled
  }

  set {
    name  = "postgresql.enabled"
    value = var.posgresql_enabled
  }

  set {
    name  = "postgresql.existingSecret"
    value = kubernetes_secret.feast_postgresql_secret.metadata[0].name
  }

  set {
    name  = "kafka.enabled"
    value = var.kafka_enabled
  }

  set {
    name  = "redis.enabled"
    value = var.redis_enabled
  }

  set {
    name  = "redis.use_password"
    value = var.redis_use_password
  }

  set {
    name  = "prometheus-statsd-exporter.enabled"
    value = var.promethues_statsd_exporter_enabled
  }

  set {
    name  = "prometheus.enabled"
    value = var.prometheus_enabled
  }

  set {
    name  = "grafana.enabled"
    value = var.grafana_enabled
  }
}