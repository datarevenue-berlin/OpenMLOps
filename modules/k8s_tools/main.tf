
resource "helm_release" "metrics-server" {
  count = var.install_metrics_server ? 1 : 0
  repository = "https://charts.bitnami.com/bitnami"
  version    = "5.8.5"
  name       = "metrics-server"
  chart      = "metrics-server"
  namespace  = "kube-system"

  set {
    name = "apiService.create"
    value = "true"
  }
}
