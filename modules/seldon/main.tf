resource "helm_release" "seldon" {
  name      = "seldon-core"
  namespace = var.namespace

  repository = "https://storage.googleapis.com/seldon-charts"
  chart      = "seldon-core-operator"
  version    = "1.12.0"

  values = [templatefile("${path.module}/values.yaml", {
    usage_metrics_enabled = var.usage_metrics_enabled
  })]
}