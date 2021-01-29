variable "region" {
  default     = "eu-west-1"
  description = "AWS region"
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::827659017777:user/Kayibal"
      username = "Kayibal"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::827659017777:user/tamara"
      username = "tamara"
      groups   = ["system:masters"]
    },
  ]
}



## MLFlow Config
##
variable "mlflow_namespace" {
  default = "mlflow"
}

variable "database_name" {
  default = "mlflow"
}
variable "db_password" {
  default = "my-secret-password"
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
variable "jupyterhub_namespace" {
  default = "jhub"
}


variable "jhub_proxy_https_enabled" {
  default = true
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
  default = false
}

variable "oauth_github_client_id" {
  description = "github client id used on GitHubOAuthenticator"
  default = ""
}
variable "oauth_github_client_secret" {
  description = "github secret used to authenticate with github"
  default = ""
}

variable "oauth_github_admin_users" {
  description = "Github user names to allow as administrator"
  default = ""
}

variable "oauth_github_callback_url" {
  default = ""
}

variable "oauth_github_allowed_organizations" {
  default = [""]
}


locals {
  jhub_github_auth = {
      github = {
        clientId = var.oauth_github_client_id
        clientSecret = var.oauth_github_client_secret
        callbackUrl = var.oauth_github_callback_url
        orgWhiteList = var.oauth_github_allowed_organizations
      }
      scope = ["read:user"]
      admin = {
        users = var.oauth_github_admin_users
      }
      JupyterHub = {
        authenticator_class =  "github"
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



