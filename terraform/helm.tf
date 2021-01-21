
locals {
  jupyterhub_namespace = "jhub"
}

resource "kubernetes_namespace" "jupyterhub_namespace" {
  metadata {
    name = local.jupyterhub_namespace
  }
}

resource "kubernetes_secret" "private_registry_secret" {
  metadata {
    name      = "regcred"
    namespace = local.jupyterhub_namespace
  }
  data = {
    ".dockerconfigjson" = file(pathexpand("~/.docker/config.json"))
  }

  type = "kubernetes.io/dockerconfigjson"
}


resource "helm_release" "jupyterhub_lab" {
  name      = "jupyterhub"
  namespace = local.jupyterhub_namespace

  repository = "https://jupyterhub.github.io/helm-chart"
  chart      = "jupyterhub"
  version    = "0.10.6"


  values = [
    file("${path.module}/jupyterhub-config/config.yaml"),
  ]
}


