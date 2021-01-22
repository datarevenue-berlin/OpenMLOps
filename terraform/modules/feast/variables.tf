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

variable "posgresql_enabled" {
  default = true
}

variable "kafka_enabled" {
  default = false
}

variable "redis_enabled" {
  default = true
}

variable "redis_use_password" {
  default = false
}

variable "promethues_statsd_exporter_enabled" {
  default = false
}

variable "prometheus_enabled" {
  default = false
}

variable "grafana_enabled" {
  default = false
}