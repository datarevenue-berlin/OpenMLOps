variable "namespace" {
  description = "Namespace name to deploy the application"
  default     = "default"
}

variable "feast_postgresql_password" {
  description = "Postgress Password"
}

variable "feast_core_enabled" {
  description = "Flag to install Feast Core"
  default     = true
}

variable "feast_online_serving_enabled" {
  default = true
}

variable "feast_jupyter_enabled" {
  default = false
}

variable "feast_jobservice_enabled" {
  default = true
}

variable "feast_posgresql_enabled" {
  default = true
}

variable "feast_kafka_enabled" {
  default = false
}

variable "feast_redis_enabled" {
  default = true
}

variable "feast_redis_use_password" {
  default = false
}

variable "feast_redis_disable_commands" {
  default = ""
}

variable "feast_prometheus_enabled" {
  default = false
}

variable "feast_prometheus_statsd_exporter_enabled" {
  default = false
}

variable "feast_grafana_enabled" {
  default = false
}

variable "feast_spark_operator_image_tag" {
  default = "v1beta2-1.1.2-2.4.5"
}

variable "feast_spark_operator_cluster_role_name" {
  default = ""
}
