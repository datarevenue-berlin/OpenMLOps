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
  default     = [""]
}

## Jupyter Hub

variable "install_jupyterhub" {
  default = true
}

variable "jupyterhub_namespace" {
  default = "jhub"
}

variable "jhub_proxy_https_enabled" {
  default = false
}

variable "jhub_proxy_https_hosts" {
  default = [""]
}

variable "jhub_proxy_secret_token" {
  default = ""
}

variable "jhub_proxy_https_letsencrypt_contact_email" {
  default = ""
}

variable "jhub_proxy_service_type" {
  description = "Whether to expose the service publicly or internally"
  type = string
  default = "LoadBalancer"
}

variable "oauth_github_enable" {
  description = "Defines whether the authentication will be handled by github oauth"
  default     = false
}

variable "oauth_github_client_id" {
  description = "github client id used on GitHubOAuthenticator"
  default     = ""
}
variable "oauth_github_client_secret" {
  description = "github secret used to authenticate with github"
  default     = ""
}

variable "oauth_github_admin_users" {
  description = "Github user names to allow as administrator"
  default     = []
}

variable "oauth_github_callback_url" {
  description = "The URL that people are redirected to after they authorize your GitHub App to act on their behalf"
  default     = ""
}

variable "oauth_github_allowed_organizations" {
  description = "List of Github organization to restrict access to the members"
  default     = [""]
}

variable "singleuser_profile_list" {
  description = "List of images which the user can select to spawn a server"
  type = list(
    object({
      display_name = string
      description  = string
      default      = bool
      kubespawner_override = object({
        image = string
      })
  }))

  default = [
    {
      display_name = "Notebook with Prefect"
      description  = "Notebook with prefect installed <br> Image: drtools/prefect:notebook-prefect"
      default      = true
      kubespawner_override = {
        image = "drtools/prefect:notebook-prefect"
      }
    },

    {
      display_name = "Data Science environment"
      description  = "Default data science environment"
      default      = false
      kubespawner_override = {
        image = "jupyter/datascience-notebook:2343e33dec46"
      }
    }
  ]
}


locals {
  jhub_auth_config = {
    dummy = {
      password = "a-shared-secret-password"
    }
    github = {
      clientId     = var.oauth_github_client_id
      clientSecret = var.oauth_github_client_secret
      callbackUrl  = var.oauth_github_callback_url
      orgWhiteList = var.oauth_github_allowed_organizations
    }
    scope = ["read:user"]
    admin = {
      users = var.oauth_github_admin_users
    }
  }
}


## Dask

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

## Seldon

variable "install_seldon" {
  default = true
}

variable "seldon_namespace" {
  default = "seldon"
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
