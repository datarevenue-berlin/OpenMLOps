variable "namespace" {
  description = "Namespace name to deploy the application"
  default     = "default"
}

variable "ambassador_namespace" {
  description = "Namespace name to deploy Ambassador"
  default     = "ambassador"
}

variable "ambassador_enabled" {
  default = true
}

variable "usage_metrics_enabled" {
  default = true
}

variable "aws" {
  description = "If the deployment is being made in an AWS Cluster"
  default = false
}

variable "tls_certificate_arn" {
  description = "TLS Certificate ARN"
  default = ""
}

variable "hostname" {
  description = "Application hostname ex.: mlops.mywebsite.com"
}