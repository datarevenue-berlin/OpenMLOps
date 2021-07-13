variable "seldon_namespace" {
  description = "Namespace name to deploy the application"
  default     = "default"
}

variable "usage_metrics_enabled" {
  default = true
}