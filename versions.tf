terraform {
  required_version = ">= 0.13"
  required_providers {
    http = {
      source = "hashicorp/http"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.0"
    }
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = lookup(var.kubernetes, "host", null)
    token                  = lookup(var.kubernetes, "token", null)
    cluster_ca_certificate = lookup(var.kubernetes, "cluster_ca_certificate", null)
    config_path            = lookup(var.kubernetes, "config_path", null)
    config_context         = lookup(var.kubernetes, "config_context", null)
  }
}

provider "kubernetes" {
  host                   = lookup(var.kubernetes, "host", null)
  token                  = lookup(var.kubernetes, "token", null)
  cluster_ca_certificate = lookup(var.kubernetes, "cluster_ca_certificate", null)
  config_path            = lookup(var.kubernetes, "config_path", null)
  config_context         = lookup(var.kubernetes, "config_context", null)
}
