# Cluster Variables
variable "region" {
  default     = "eu-west-1"
  description = "AWS region"
}


# Docker Registry
variable registry_username {
  type        = string
  description = "Docker username credential"
  sensitive = true
}

variable registry_password {
  type        = string
  description = "Docker password credential"
  sensitive = true
}

