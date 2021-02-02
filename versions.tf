terraform {
  backend "s3" {
    bucket = "eks-mlops-tf-state"
    key    = "terraform-dev.tfstate"
    region = "eu-west-1"
  }
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
      version = "2.0.0"
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
