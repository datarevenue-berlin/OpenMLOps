variable "namespace" {
  description = "Namespace name to deploy the application"
  default     = "default"
}

variable "ambassador_namespace" {
  description = "Namespace name to deploy Ambassador"
  default     = "ambassador"
}

variable "istio_enabled" {
  default = true
}

variable "usage_metrics_enabled" {
  default = true
}