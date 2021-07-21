variable "namespace" {
  description = "Namespace name to deploy Ambassador"
  default     = "ambassador"
}

variable "ambassador_enabled" {
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

variable "tls" {
  description = "whether to use TLS encryption or not"
  type = bool
}

variable "hostname" {
  description = "Application hostname ex.: mlops.mywebsite.com"
}

variable "enable_ory_authentication" {
  description = "Whether to enable ory_authentication"
}