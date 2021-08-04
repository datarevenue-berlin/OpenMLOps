resource "kubernetes_namespace" "jupyterhub_namespace" {
  metadata {
    name = var.jupyterhub_namespace
  }
}

resource "helm_release" "jupyterhub" {
  name = "jupyterhub_1.1.1"
  version = 1.1.1
  repository = "https://jupyterhub.github.io/helm-chart/"
  chart = "jupyterhub"
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

resource "helm_release" "postgres" {
  name = "postgres_13.3"
  version = 13.3
  repository = "https://krakazyabra.github.io/microservices"
  chart = "postgres"
}

module "postgres" {
  source    = "./modules/postgres"
  namespace = kubernetes_namespace.mlflow_namespace.metadata[0].name

  db_username   = var.db_username
  db_password   = var.db_password
  database_name = var.database_name
}

resource "helm_release" "mlflow" {
  name = "mlflow_1.5.0"
  version = 1.5.0
  repository = "https://cetic.github.io/helm-charts"
  chart = "mlflow"
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

# TODO: There is no prefect module in the helm hub

module "prefect-server" {
  source    = "./modules/prefect-server"
  namespace = kubernetes_namespace.prefect_namespace.metadata[0].name

  parent_module_name = basename(abspath(path.module))
  hostname = var.hostname
  protocol = var.protocol
  service_type = var.prefect_service_type
  agent_prefect_labels = var.prefect_agent_labels
  service_account_name = var.prefect_service_account_name
  seldon_manager_cluster_role_name = var.install_seldon ? "seldon-manager-role-${var.seldon_namespace}" : ""
  feast_spark_operator_cluster_role_name = var.install_feast ? var.feast_spark_operator_cluster_role_name : ""
}


resource "kubernetes_namespace" "dask_namespace" {
  metadata {
    name = var.dask_namespace
  }
}

resource "helm_release" "dask" {
  name = "dask_2021.7.2"
  version = 2021.7.2
  repository = "https://helm.dask.org/"
  chart = "dask"
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

# TODO: There is no feast module in the helm hub

module "feast" {
  count = var.install_feast ? 1 : 0

  source    = "./modules/feast"
  namespace = kubernetes_namespace.feast_namespace[0].metadata[0].name

  feast_core_enabled           = true
  feast_online_serving_enabled = true
  feast_posgresql_enabled      = true
  feast_redis_enabled          = true

  feast_postgresql_password = var.feast_postgresql_password
  feast_spark_operator_cluster_role_name = var.feast_spark_operator_cluster_role_name
}


resource "kubernetes_namespace" "seldon_namespace" {
  count = var.install_seldon ? 1 : 0
  metadata {
    name = var.seldon_namespace
  }
}

resource "helm_release" "Seldon" {
  name = "Seldon_1.7.0"
  version = 1.7.0
  chart = "https://operatorhub.io/install/stable/seldon-operator.yaml"
}

module "seldon" {
  count = var.install_seldon ? 1 : 0
  source    = "./modules/seldon"
  namespace = kubernetes_namespace.seldon_namespace[0].metadata[0].name
}

resource "kubernetes_namespace" "ambassador_namespace" {
  count = var.ambassador_enabled ? 1 : 0
  metadata {
    name = var.ambassador_namespace
  }
}

resource "helm_release" "ambassador" {
  name = "ambassador_1.13.10"
  version = 1.13.10
  repository = "https://getambassador.io/"
  chart = "ambassador"
}

module "ambassador" {
  count = var.ambassador_enabled ? 1 : 0
  source    = "./modules/ambassador"
  namespace = var.ambassador_namespace

  aws = var.aws
  tls_certificate_arn = var.tls_certificate_arn

  hostname = var.hostname
  tls = var.protocol == "https" ? true : false
  enable_ory_authentication = var.enable_ory_authentication
}


resource "kubernetes_namespace" "ory_namespace" {
  count = var.enable_ory_authentication ? 1 : 0
  metadata {
    name = var.ory_namespace
  }
}

resource "helm_release" "ory_kratos" {
  name = "ory_kratos_0.18.0"
  version = 0.18.0
  repository = "https://k8s.ory.sh/helm/charts"
  chart = "ory_kratos"
}

module "ory" {
  source = "./modules/ory"
  namespace = kubernetes_namespace.ory_namespace[0].metadata[0].name
  cookie_secret = var.ory_kratos_cookie_secret
  kratos_db_password = var.ory_kratos_db_password
  oauth2_providers = var.oauth2_providers

  hostname = var.hostname
  protocol = var.protocol

  enable_registration = var.enable_registration_page

  access_rules_path = var.access_rules_path
}

module "k8s_tools" {
  source = "./modules/k8s_tools"
  install_metrics_server = var.install_metrics_server
}