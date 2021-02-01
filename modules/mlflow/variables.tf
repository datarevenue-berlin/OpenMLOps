variable "namespace" {
  description = "Namespace name to deploy the application"
  default     = "default"
}

variable "db_username" {
  description = "Database username"
}

variable "db_password" {
  description = "Database password"
}

variable "db_host" {
  description = "Database host address"
}

variable "database_name" {
  description = "Database name"
  default     = "mlflow"
}

variable "db_port" {
  description = "Database port number"
  default     = 5432
}

variable "default_artifact_root" {
  description = "A local or remote filepath (e.g. s3://my-bucket). It is mandatory when specifying a database backend store"
  default     = "/tmp"
}

variable "image_pull_policy" {
  description = "Image pull policy"
  default     = "IfNotPresent"
}

variable "image_repository" {
  description = "Image repository"
  default     = "drtools/mlflow"
}

variable "image_tag" {
  description = "Image tag"
  default     = "1.13.1"
}

variable "service_type" {
  default = "NodePort"
}