resource "kubernetes_namespace" "daskhub_namespace" {
  metadata {
    name = "daskhub"
  }
}

module "dask-jupyterhub" {
    source    = "./modules/dask-jupyterhub"
    namespace = kubernetes_namespace.daskhub_namespace.metadata[0].name
}

resource "kubernetes_service_account" "daskhub-sa" {
  metadata {
    name      = "daskhub-sa"
    namespace = kubernetes_namespace.daskhub_namespace.metadata[0].name
  }
}

resource "kubernetes_role" "daskhub-role" {
  metadata {
    name = "daskhub-role"
    namespace = kubernetes_namespace.daskhub_namespace.metadata[0].name
  }

  rule {
    api_groups     = [""]
    resources      = ["pods"]
    verbs          = ["get", "list", "watch", "create", "delete"]
  }

  rule {
    api_groups     = [""]
    resources      = ["pods/logs"]
    verbs          = ["get", "list"]
  }

  rule {
    api_groups     = [""]
    resources      = ["services"]
    verbs          = ["get", "list", "watch", "create", "delete"]
  }

  rule {
    api_groups     = ["policy"]
    resources      = ["poddisruptionbudgets"]
    verbs          = ["get", "list", "watch", "create", "delete"]
  }
}

resource "kubernetes_role_binding" "daskhub-rb" {
  metadata {
    name = "daskhub-rb"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "daskhub-role"
  }

  subject {
    kind = "ServiceAccount"
    name = "daskhub-sa"
  }
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

module "ory" {
  source = "./modules/ory"
  namespace = kubernetes_namespace.ory_namespace[0].metadata[0].name
  cookie_secret = var.ory_kratos_cookie_secret
  kratos_db_password = var.ory_kratos_db_password
  oauth2_providers = var.oauth2_providers

  hostname = var.hostname
  protocol = var.protocol

  enable_registration = var.enable_registration_page
  enable_password_recovery = var.enable_password_recovery
  enable_verification = var.enable_verification
  smtp_connection_uri = var.smtp_connection_uri
  smtp_from_address = var.smtp_from_address

  access_rules_path = var.access_rules_path
}

module "k8s_tools" {
  source = "./modules/k8s_tools"
  install_metrics_server = var.install_metrics_server
}