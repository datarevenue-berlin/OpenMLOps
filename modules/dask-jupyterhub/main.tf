resource "helm_release" "dask-jupyterhub" {
  name      = "daskhub"
  namespace = "daskhub"

  repository = "https://helm.dask.org"
  chart      = "daskhub"
  version    = "2021.7.2"

}