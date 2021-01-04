
locals {
    jupyterhub_namespace = "jhub"
    prefect_namespace = "prefect"
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
# PREFECT SERVER #
##################

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

    set {
      name  = "agent.enabled"
      value = "true"
    }

}


########
# DASK #
########


