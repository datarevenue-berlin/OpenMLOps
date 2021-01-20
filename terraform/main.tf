module "postgres" {
    source = "./modules/postgres"
    namespace = var.mlflow_namespace

    db_username = var.db_username
    db_password = var.db_password
    database_name = var.database_name
}

module "mlflow" {
    source = "./modules/mlflow"
    namespace = var.mlflow_namespace
    
    db_host = module.postgres.db_host
    db_username = var.db_username
    db_password = var.db_password
    default_artifact_root = var.mlflow_artifact_root
}

