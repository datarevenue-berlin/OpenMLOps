variable "namespace" {
  description = "Namespace name to deploy the application"
  default     = "default"
}

variable "istio_enabled" {
  default = true
}

variable "usage_metrics_enabled" {
  default = true
}