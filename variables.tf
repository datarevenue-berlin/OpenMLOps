## General variables
variable "hostname" {
  description = "Hostname of the deployed cluster. Ex.: my-mlops.com"
}

variable "protocol" {
  default = "http"
  description = "Preferred connection protocol. If using https, a valid ACM certificate must be provided under tls_certificate_arn. See documentation"
}

## MLFlow

variable "mlflow_namespace" {
  default = "mlflow"
}

variable "database_name" {
  default = "mlflow"
}
variable "db_password" {
  description = "Database password"
}

variable "db_username" {
  default = "postgres"
}

variable "mlflow_artifact_root" {
  default = "s3://mlops-model-artifact"
}

variable "mlflow_docker_private_repo" {
  description = "Whether the MLFlow's image comes from a private repository or not. If true, mlflow_docker_registry_server and mlflow_docker_auth_key will be required"
  type = bool
  default = false
}
variable "mlflow_docker_registry_server" {
  description = "Docker Registry Server where the MLFlow image should be found"
  type = string
  default = ""
}
variable "mlflow_docker_auth_key" {
  description = "Base64 encoded auth key for the registry server"
  type = string
  default = ""
}

variable "mlflow_service_type" {
  description = "Whether to expose the service publicly or internally"
  type = string
  default = "LoadBalancer"
}

## Prefect Server

variable "prefect_namespace" {
  default = "prefect"
}

variable "prefect_service_type" {
  description = "Whether to expose the service publicly or internally"
  type = string
  default = "LoadBalancer"
}

variable "prefect_agent_labels" {
  description = "Defines what scheduling labels (not K8s labels) should be associated with the agent"
  default     = ["dev"]
}

variable "prefect_service_account_name" {
  description = "Prefect service account name"
  default = "prefect-server-serviceaccount"
}

variable "prefect_create_tenant_enabled" {
  description = "determines if the Prefect tenant is created automatically"
  default     = true
}

## Dask

variable "install_daskhub" {
  default = true
}

variable "daskhub_service_type" {
  description = "Whether to expose the service publicly or internally"
  type = string
  default = "LoadBalancer"
}

variable "dask_namespace" {
  default = "dask"
}

## Feast

variable "install_feast" {
  default = false
}

variable "feast_namespace" {
  default = "feast"
}

variable "feast_postgresql_password" {
  default = "my-feast-password"
}

variable "feast_spark_operator_cluster_role_name" {
  default = "feast-spark-operator"
}

## Seldon

variable "install_seldon" {
  default = true
}

variable "seldon_namespace" {
  default = "seldon"
}

## Ambassador
variable "ambassador_namespace" {
  default = "ambassador"
}

variable "ambassador_enabled" {
  default = true
}

variable "aws" {
  description = "If the deployment is being made in an AWS Cluster"
}

variable "tls_certificate_arn" {
  description = "TLS Certificate ARN"
  default = ""
}

## ORY (authentication module)

variable "enable_ory_authentication" {
  default = true
}
variable "ory_namespace" {
  default = "ory"
}

variable "ory_kratos_db_password"{
  description = "PostgreSQL Database Password"
}

variable "ory_kratos_cookie_secret" {
  description = "Session Cookie Generation secret"
  sensitive = true
}

variable "oauth2_providers" {
  //  Configure multiple Oauth2 providers.
  //  example:
  //  [{
  //    provider = github
  //    client_id = change_me
  //    client_secret = change_me
  //    tenant = null
  //  }]
  //  If you're using GitHub, Google or Facebook, tenant won't be needed, so please set
  //  it as null or an empty string. It is required for AzureAd
  type = list(object({
    provider = string
    client_id = string
    client_secret = string
    tenant = string
  }))
  description = "OAuth2 Providers credentials"
}

variable "smtp_connection_uri" {
  description = "SMTP Connection for Ory"
  type = string
  default = "smtp://"
}

variable "smtp_from_address" {
  description = "Email address for outgoing mails from Ory"
  type = string
  default = ""
}

variable "enable_password_recovery" {
  description = "Bool to set to enable password recovery using emails"
  type = bool
  default = false
}

variable "enable_verification" {
  description = "Bool to set to enable account registration confirmation using emails"
  type = bool
  default = false
}

## Other K8S tools

variable "install_metrics_server" {
  default = true
}

variable "enable_registration_page" {
  description = "Bool to set if registration page will or not be visible to users"
  type = bool
  default = true
}

variable "access_rules_path" {
  type = string
  default = null
}
