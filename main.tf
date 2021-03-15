resource "kubernetes_namespace" "jupyterhub_namespace" {
  metadata {
    name = var.jupyterhub_namespace
  }
}

module "jupyterhub" {
  count     = var.install_jupyterhub ? 1 : 0
  source    = "./modules/jupyterhub"
  namespace = kubernetes_namespace.jupyterhub_namespace.metadata[0].name

  # Proxy settings
  proxy_secret_token                    = var.jhub_proxy_secret_token
  proxy_https_enabled                   = var.jhub_proxy_https_enabled
  proxy_https_hosts                     = var.jhub_proxy_https_hosts
  proxy_https_letsencrypt_contact_email = var.jhub_proxy_https_letsencrypt_contact_email
  proxy_service_type                    = var.jhub_proxy_service_type

  # Authentication settings
  # Following values should be `null` if oauth_github is disabled. However we need to pass submodule's defaults here
  # explicitly because of this Terraform bug: https://github.com/hashicorp/terraform/issues/21702
  authentication_type   = var.oauth_github_enable ? "github" : "dummy"
  authentication_config = merge(
    local.jhub_auth_config,
    {JupyterHub = {authenticator_class = var.oauth_github_enable ? "github" : "dummy"}}
  )

  # Profile list configuration
  singleuser_profile_list = var.singleuser_profile_list
}


resource "kubernetes_namespace" "mlflow_namespace" {
  metadata {
    name = var.mlflow_namespace
  }
}

module "postgres" {
  source    = "./modules/postgres"
  namespace = kubernetes_namespace.mlflow_namespace.metadata[0].name

  db_username   = var.db_username
  db_password   = var.db_password
  database_name = var.database_name
}

module "mlflow" {
  source    = "./modules/mlflow"
  namespace = kubernetes_namespace.mlflow_namespace.metadata[0].name

  db_host               = module.postgres.db_host
  db_username           = var.db_username
  db_password           = var.db_password
  default_artifact_root = var.mlflow_artifact_root
  docker_private_repo   = var.mlflow_docker_private_repo
  docker_registry_server = var.mlflow_docker_registry_server
  docker_auth_key       = var.mlflow_docker_auth_key

  service_type = var.mlflow_service_type
}



resource "kubernetes_namespace" "prefect_namespace" {
  metadata {
    name = var.prefect_namespace
  }
}

module "prefect-server" {
  source    = "./modules/prefect-server"
  namespace = kubernetes_namespace.prefect_namespace.metadata[0].name
  parent_module_name = basename(abspath(path.module))
  hostname = var.hostname
  protocol = var.protocol
  service_type = var.prefect_service_type
}



resource "kubernetes_namespace" "dask_namespace" {
  metadata {
    name = var.dask_namespace
  }
}


module "dask" {

  source    = "./modules/dask"
  namespace = kubernetes_namespace.dask_namespace.metadata[0].name

  worker_image_pull_secret = [
    {
      name = "regcred"
    }
  ]
  worker_environment_variables = [
    {
      name  = "EXTRA_CONDA_PACKAGES"
      value = "python==3.7 -c conda-forge"
    },
    {
      name  = "EXTRA_PIP_PACKAGES"
      value = "prefect==0.14.1 --upgrade"
    }
  ]
}



resource "kubernetes_namespace" "feast_namespace" {
  count = var.install_feast ? 1 : 0
  metadata {
    name = var.feast_namespace
  }
}

module "feast" {
  count = var.install_feast ? 1 : 0

  source    = "./modules/feast"
  namespace = kubernetes_namespace.feast_namespace[0].metadata[0].name

  feast_core_enabled           = true
  feast_online_serving_enabled = true
  feast_posgresql_enabled      = true
  feast_redis_enabled          = true

  feast_postgresql_password = var.feast_postgresql_password
}


resource "kubernetes_namespace" "seldon_namespace" {
  count = var.install_seldon ? 1 : 0
  metadata {
    name = var.seldon_namespace
  }
}

module "seldon" {
  count = var.install_seldon ? 1 : 0
  source    = "./modules/seldon"
  namespace = kubernetes_namespace.seldon_namespace[0].metadata[0].name

  aws = var.aws
  tls_certificate_arn = var.tls_certificate_arn

  hostname = var.hostname
  tls = var.protocol == "https" ? true : false
}

resource "kubernetes_namespace" "ory_namespace" {
  count = var.enable_ory_authentication ? 1 : 0
  metadata {
    name = var.ory_namespace
  }
}

module "ory" {
  source = "./modules/ory"
  namespace = kubernetes_namespace.ory_namespace[0].metadata[0].name
  cookie_secret = var.ory_kratos_cookie_secret
  db_password = var.ory_kratos_db_password
  oauth2_providers = var.oauth2_providers

  hostname = var.hostname
  protocol = var.protocol
}