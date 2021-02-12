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

## Prefect Server

variable "prefect_namespace" {
  default = "prefect"
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
  default     = ""
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
  jhub_github_auth = {
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
    JupyterHub = {
      authenticator_class = "github"
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

