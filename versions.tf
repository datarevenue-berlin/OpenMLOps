terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.20"
    }
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

provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {
    host                   = lookup(local.kubernetes, "host", null)
    token                  = lookup(local.kubernetes, "token", null)
    cluster_ca_certificate = lookup(local.kubernetes, "cluster_ca_certificate", null)
    config_path            = lookup(local.kubernetes, "config_path", null)
    config_context         = lookup(local.kubernetes, "config_context", null)
  }
}

provider "kubernetes" {
  host                   = lookup(local.kubernetes, "host", null)
  token                  = lookup(local.kubernetes, "token", null)
  cluster_ca_certificate = lookup(local.kubernetes, "cluster_ca_certificate", null)
  config_path            = lookup(local.kubernetes, "config_path", null)
  config_context         = lookup(local.kubernetes, "config_context", null)
}
