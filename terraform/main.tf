resource "kubernetes_namespace" "mlflow_namespace" {
  metadata {
    name = var.mlflow_namespace
  }
}


module "postgres" {
  source    = "./modules/postgres"
  namespace = var.mlflow_namespace

  db_username   = var.db_username
  db_password   = var.db_password
  database_name = var.database_name
}

module "mlflow" {
  source    = "./modules/mlflow"
  namespace = var.mlflow_namespace

  db_host               = module.postgres.db_host
  db_username           = var.db_username
  db_password           = var.db_password
  default_artifact_root = var.mlflow_artifact_root
}



resource "kubernetes_namespace" "prefect_namespace" {
  metadata {
    name = var.prefect_namespace
  }
}

module "prefect-server" {
  source    = "./modules/prefect-server"
  namespace = var.prefect_namespace
}



resource "kubernetes_namespace" "dask_namespace" {
  metadata {
    name = var.dask_namespace
  }
}


module "dask" {

  source    = "./modules/dask"
  namespace = var.dask_namespace

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
  namespace = var.feast_namespace

  feast_core_enabled           = true
  feast_online_serving_enabled = true
  posgresql_enabled            = true
  redis_enabled                = true

  feast_postgresql_password = var.feast_postgresql_password
}