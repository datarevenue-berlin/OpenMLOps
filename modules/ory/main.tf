locals {
  config_mount_path = "/etc/config"
}

data "template_file" "oathkeeper-access-rules"{
  template = file("${path.module}/access-rule-oathkeeper.yaml")
  vars = {
    hostname = var.hostname
  }
}

data "template_file" "oathkeeper-config"{
  template = file("${path.module}/config-oathkeeper.yaml")
  vars = {
    hostname = var.hostname
    protocol = var.protocol
    config_path = local.config_mount_path
  }
}

resource "kubernetes_config_map" "oathkeeper-configs" {
  metadata {
    name = "oathkeeper-config"
    namespace = var.namespace
  }
  data = {
    "access-rule-oathkeeper.yaml" = data.template_file.oathkeeper-access-rules.rendered
    "config-oathkeeper.yaml" = data.template_file.oathkeeper-config.rendered
  }
}

resource "kubernetes_service" "ory-oathkeeper" {
  metadata {
    name = "ory-oathkeeper"
    namespace = var.namespace
    annotations = {
      "getambassador.io/config" = <<YAML
---
apiVersion: getambassador.io/v2
kind: Mapping
name: ory-oathkeeper_mapping
service: ory-oathkeeper.ory
prefix: /ory-oathkeeper/
---
apiVersion: getambassador.io/v2
kind: AuthService
name: authentication
auth_service: ory-oathkeeper.ory
path_prefix: /decisions
allowed_request_headers:
  - Authorization
allowed_authorization_headers:
  - Authorization
YAML
    }
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = "ory-oathkeeper"
    }
    port {
      port = 80
      name = "http-ory-oathkeeper"
      target_port = "http-api"
    }
  }
}

resource "kubernetes_secret" "ory-authkeeper-issuer-secret" {
  metadata {
    name = "ory-oathkeeper-issuer"
    namespace = var.namespace
  }
  data = {
    credentials_issuer_id = var.credentials_issuer_id
  }
}
resource "kubernetes_deployment" "ory-oathkeeper" {
  metadata {
    name = "ory-oathkeeper"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "ory-oathkeeper"
      }
    }
    strategy {
      type = "RollingUpdate"
    }
    template {
      metadata {
        labels = {
          app = "ory-oathkeeper"
        }
      }
      spec {
        container {
          name = "ory-oathkeeper"
          image = "oryd/oathkeeper:v0.38.6-alpine"
          image_pull_policy = "Always"
          command = ["oathkeeper", "serve", "api", "--config", "${local.config_mount_path}/config-oathkeeper.yaml"]

          env {
            name = "DATABASE_URL"
            value = "memory"
          }
          env {
            name = "CREDENTIALS_ISSUER_ID_TOKEN_ALGORITHM"
            value = "HS256"
          }
          env {
            name = "PORT"
            value = "4456"
          }
          env {
            name = "CREDENTIALS_ISSUER_ID_TOKEN_HS256_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.ory-authkeeper-issuer-secret.metadata[0].name
                key = "credentials_issuer_id"
              }
            }
          }
          env {
            name = "ACCESS_RULES_REPOSITORIES"
            value = "file:/${local.config_mount_path}/access-rule-oathkeeper.yaml"
          }
          port {
            name = "http-api"
            container_port = 4456
          }
          resources {
            limits {
              cpu = "0.1"
              memory = "100Mi"
            }
          }
          volume_mount {
            name = "oathkeeper-access-rule-vol"
            mount_path = local.config_mount_path
          }
        }
        volume {
          name = "oathkeeper-access-rule-vol"
          config_map {
            name = kubernetes_config_map.oathkeeper-configs.metadata[0].name
          }
        }
      }
    }
  }
}

module "ory-kratos" {
  source = "./kratos"
  namespace = var.namespace
}