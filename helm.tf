//
//locals {
//  jupyterhub_namespace = "jhub"
//}
//
//resource "kubernetes_namespace" "jupyterhub_namespace" {
//  metadata {
//    name = local.jupyterhub_namespace
//  }
//}
//
//resource "kubernetes_secret" "private_registry_secret" {
//  metadata {
//    name      = "regcred"
//    namespace = local.jupyterhub_namespace
//  }
//  data = {
//    ".dockerconfigjson" = file(pathexpand("~/.docker/config.json"))
//  }
//
//  type = "kubernetes.io/dockerconfigjson"
//}
//
//
//resource "helm_release" "jupyterhub_lab" {
//  name      = "jupyterhub"
//  namespace = local.jupyterhub_namespace
//
//  repository = "https://jupyterhub.github.io/helm-chart"
//  chart      = "jupyterhub"
//  version    = "0.10.6"
//
//
//  values = [
//    file("${path.module}/jupyterhub-config/config.yaml"),
//  ]
//}
//
//
//
//
//resource "kubernetes_service_account" "dask_jupyter_sa" {
//  metadata {
//    name      = "dask-jupyter-sa"
//    namespace = local.jupyterhub_namespace
//    labels = {
//      //      app     = module.dask.name
//      //      release = module.dask.name
//      component : "jupyter"
//    }
//  }
//}
//
//resource "kubernetes_cluster_role" "dask_jupyter_cr" {
//  metadata {
//    name = "dask-jupyter-cr"
//    labels = {
//      //      app     = module.dask.name
//      //      release = module.dask.name
//      component : "jupyter"
//    }
//  }
//
//  rule {
//    api_groups = [""]
//    resources  = ["deployments"]
//    verbs      = ["get", "list", "watch", "update", "patch"]
//  }
//
//  rule {
//    api_groups = [""]
//    resources  = ["pods"]
//    verbs      = ["get", "list", "watch"]
//  }
//
//  rule {
//    api_groups = [""]
//    resources  = ["pods/logs"]
//    verbs      = ["get", "list", "watch"]
//  }
//
//}
//
//resource "kubernetes_cluster_role_binding" "dask_jupyter_crb" {
//  metadata {
//    name = "dask-jupyter-crb"
//    labels = {
//      //      app     = module.dask.name
//      //      release = module.dask.name
//      component : "jupyter"
//    }
//
//  }
//  role_ref {
//    api_group = "rbac.authorization.k8s.io"
//    kind      = "ClusterRole"
//    name      = "dask-jupyter-rb"
//  }
//  subject {
//    kind = "ServiceAccount"
//    name = "dask-jupyter-sa"
//  }
//}
