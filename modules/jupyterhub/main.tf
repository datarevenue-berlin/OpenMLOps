


resource "kubernetes_secret" "private_registry_secret" {
  metadata {
    name      = "regcred"
    namespace = var.namespace
  }
  data = {
    ".dockerconfigjson" = file(pathexpand("~/.docker/config.json"))
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "helm_release" "jupyterhub_lab" {
  name      = "jupyterhub"
  namespace = var.namespace

  repository = "https://jupyterhub.github.io/helm-chart"
  chart      = "jupyterhub"
  version    = "0.10.6"

  set {
    name  = "hub.allowNamedServers"
    value = var.hub_allowed_named_servers
  }

  set {
    name  = "proxy.secretToken"
    value = var.proxy_secret_token
  }

  set {
    name  = "proxy.https.enabled"
    value = var.proxy_https_enabled
  }

  set {
    name  = "proxy.https.letsencrypt.contactEmail"
    value = var.proxy_https_letsencrypt_contact_email
  }

  set {
    name  = "auth.type"
    value = var.authentication_type
  }

  values = [
    yamlencode({
      custom = {
        a = "workaround to the issue https://github.com/jupyterhub/zero-to-jupyterhub-k8s/issues/1998"
      }
      auth = var.authentication_config
      proxy = {
        https = {
          hosts = var.proxy_https_hosts
        }
      }

      singleuser = {
        serserviceAccountName = kubernetes_service_account.dask_jupyter_sa.metadata[0].name
        defaultUrl            = var.singleuser_default_url
        image = {
          pullSecrets = var.singleuser_image_pull_secrets
          pullPolicy  = var.singleuser_image_pull_policy
        }

        profileList = var.singleuser_profile_list
        memory = {
          guarantee = var.singleuser_memory_guarantee
        }
        storage = {
          capacity      = var.singleuser_storage_capacity
          homeMountPath = var.singleuser_storage_mount_path
        }
        extraEnv = {
          TZ = "Europe/Berlin"
        }
      }
      }
    )
  ]

}


resource "kubernetes_service_account" "dask_jupyter_sa" {
  metadata {
    name      = "dask-jupyter-sa"
    namespace = var.namespace
    labels = {
      app     = var.dask_name
      release = var.dask_name
      component : "jupyter"
    }
  }
}

//resource "kubernetes_cluster_role" "dask_jupyter_cr" {
//  metadata {
//    name = "dask-jupyter-cr"
//    labels = {
//      app     = var.dask_name
//      release = var.dask_name
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

resource "kubernetes_cluster_role_binding" "dask_jupyter_crb" {
  metadata {
    name = "dask-jupyter-crb"
    labels = {
      app     = var.dask_name
      release = var.dask_name
      component : "jupyter"
    }

  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "dask-jupyter-rb"
  }
  subject {
    kind = "ServiceAccount"
    name = "dask-jupyter-sa"
  }
}

