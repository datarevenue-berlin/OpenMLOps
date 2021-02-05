resource "kubernetes_namespace" "ambdassador_namespace" {
  count = var.ambassador_enabled ? 1 : 0
  metadata {
    name = var.ambassador_namespace
  }
}

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


resource "helm_release" "ambassador" {
  count = var.ambassador_enabled ? 1 : 0
  repository = "https://www.getambassador.io"
  chart = "ambassador"
  name = "ambassador"
  namespace = var.ambassador_namespace

  set {
    name = "image.repository"
    value = "docker.io/datawire/ambassador"
  }
  set {
    name = "image.tag"
    value = "1.11.0"
  }
  set {
    name = "enableAES"
    value = "false"
  }
}