
locals {
    jupyterhub_namespace = "jhub"
    prefect_namespace = "prefect"
    dask_namespace = "dask"
    feast_namespace = "feast"
}

variable "feast_postgresql_password" {
  description = "The password for Postgresql for Feast to run"
  type = string
  sensitive = true
}

############################################
# KUBERNETES SERVICE ACCOUNT, CLUSTER ROLE #
# AND CLUSTER ROLE BINDING                 #
############################################

resource "kubernetes_service_account" "dask_jupyter_sa" {
  metadata {
    name = "dask-jupyter-sa"
    namespace = local.jupyterhub_namespace
    labels = {
      app = helm_release.dask.name
      release = helm_release.dask.name
      component: "jupyter"
    }
  }
}

resource "kubernetes_cluster_role" "dask_jupyter_cr"  {
  metadata {
    name = "dask-jupyter-cr"
    labels = {
      app = helm_release.dask.name
      release = helm_release.dask.name
      component: "jupyter"
    }
  }

  rule {
    api_groups = [""]
    resources = ["deployments"]
    verbs =  ["get", "list", "watch", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources = ["pods"]
    verbs =  ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources = ["pods/logs"]
    verbs =  ["get", "list", "watch"]
  }

}

resource "kubernetes_cluster_role_binding" "dask_jupyter_crb" {
  metadata {
    name = "dask-jupyter-crb"
    labels = {
      app = helm_release.dask.name
      release = helm_release.dask.name
      component: "jupyter"
    }

  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "dask-jupyter-rb"
  }
  subject {
    kind = "ServiceAccount"
    name = "dask-jupyter-sa"
  }
}

##################
# PREFECT SERVER #
##################

# There will soon be a helm repository for prefect server

resource "kubernetes_namespace" "prefect_namespace" {
  metadata {
    name = local.prefect_namespace
  }
}

module "prefect_server" {
  source = "git::https://github.com/PrefectHQ/server.git"
}

resource "helm_release" "prefect_server" {
    name = "prefect-server"
    namespace = local.prefect_namespace

    dependency_update = true
    chart = ".terraform/modules/prefect_server/helm/prefect-server"

    values = [
        file("${path.module}/prefect-server-config/values.yaml"),
    ]

    set {
      name  = "agent.enabled"
      value = "true"
    }

}


########
# DASK #
########

resource "kubernetes_namespace" "dask_namespace" {
  metadata {
    name = local.dask_namespace
  }
}

resource "helm_release" "dask" {
    name = "dask"
    namespace = local.dask_namespace

    repository = "https://helm.dask.org"
    chart = "dask"
    version = "4.5.6"

    values = [
        file("${path.module}/dask-config/values.yaml"),
    ]
}


#################
#  JUPYTER HUB  #
#################

resource "kubernetes_namespace" "jupyterhub_namespace" {
  metadata {
    name = local.jupyterhub_namespace
  }
}

resource "kubernetes_secret" "private_registry_secret" {
  metadata {
    name = "regcred"
    namespace = local.jupyterhub_namespace
  }
  data = {
    ".dockerconfigjson" = file(pathexpand("~/.docker/config.json"))
  }

  type = "kubernetes.io/dockerconfigjson"
}


resource "helm_release" "jupyterhub_lab" {
    name = "jupyterhub"
    namespace = local.jupyterhub_namespace

    repository = "https://jupyterhub.github.io/helm-chart"
    chart = "jupyterhub"
    version = "0.10.6"


    values = [
        file("${path.module}/jupyterhub-config/config.yaml"),
    ]
}


##################
# FEAST #
##################

resource "kubernetes_namespace" "feast_namespace" {
  metadata {
    name = local.feast_namespace
  }
}

resource "kubernetes_secret" "feast_postgresql_secret" {
  metadata {
    name = "feast-postgresql"
    namespace = local.feast_namespace
  }
  data = {
    postgresql-password = var.feast_postgresql_password
  }
}

resource "helm_release" "feast" {
    name = "feast"
    namespace = local.feast_namespace

    repository = "https://feast-charts.storage.googleapis.com"
    chart = "feast"

    values = [
        file("${path.module}/feast-config/values.yaml"),
    ]
}
