resource "helm_release" "dask-jupyterhub" {
  name      = "daskhub"
  namespace = "daskhub"

  repository = "https://helm.dask.org"
  chart      = "daskhub"
  version    = "2021.7.2"

  values = [templatefile("${path.module}/values.yaml", {
    jupyterhub_secret = var.jupyterhub_secret
    daskgateway_secret = var.daskgateway_secret
  })]
}