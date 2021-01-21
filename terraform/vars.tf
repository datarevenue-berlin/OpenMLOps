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

##
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

variable "dask_namespace" {
  default = "dask"
}


