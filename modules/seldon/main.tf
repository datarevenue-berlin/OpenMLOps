resource "helm_release" "seldon" {
  name      = "seldon-core"
  namespace = var.namespace

  repository = "https://storage.googleapis.com/seldon-charts"
  chart      = "seldon-core-operator"

  set {
    name  = "usageMetrics.enabled"
    value = var.usage_metrics_enabled
  }
}