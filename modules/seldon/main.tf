resource "helm_release" "seldon" {
  name      = "seldon-core"
  seldon_namespace = var.seldon_namespace

  repository = "https://storage.googleapis.com/seldon-charts"
  chart      = "seldon-core-operator"

  set {
    name  = "usageMetrics.enabled"
    value = var.usage_metrics_enabled
  }
}