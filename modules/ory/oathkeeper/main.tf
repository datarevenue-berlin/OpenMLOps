locals {
  config_mount_path = "/etc/config"
  secrets_mount_path = "/etc/secrets"
  access_rules_path = "${path.module}/access-rule-oathkeeper.yaml"
  configuration_defaults = yamldecode(file("config-oathkeeper.yaml"))
  configuration_default_overrides = {
    errors={
      handlers={
        redirect={
          config={
            to="${var.protocol}://${var.hostname}/profile/auth/login"
          }
        }
      }
    }
    mutators={
      id_token={
        config={
          issuer_url="${var.protocol}://${var.hostname}"
          jwk_urls="file://${local.secrets_mount_path}/id_token.jwks.json"
        }
      }
    }
  }
}

locals {
  configuration = merge(
    local.configuration_defaults,  # lowest precedence
    var.configuration_overrides,
    local.configuration_default_overrides  # highest precedence
  )
}


resource "kubernetes_config_map" "oathkeeper-configs" {
  metadata {
    name = "oathkeeper-config"
    namespace = var.namespace
  }
  data = {
    "access-rule-oathkeeper.yaml" = yamlencode(var.access_rules)
    "config-oathkeeper.yaml" = yamlencode(local.configuration)
  }
}

resource "kubernetes_service" "ory-oathkeeper" {
  metadata {
    name = "ory-oathkeeper"
    namespace = var.namespace
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
    "id_token.jwks.json" = file("${path.module}/../../../secrets/jwks.json")
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
            name = "PORT"
            value = "4456"
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
          volume_mount {
            name = "oathkeeper-secrets"
            mount_path = local.secrets_mount_path
          }
        }
        volume {
          name = "oathkeeper-access-rule-vol"
          config_map {
            name = kubernetes_config_map.oathkeeper-configs.metadata[0].name
          }
        }
        volume {
          name = "oathkeeper-secrets"
          secret {
            secret_name = kubernetes_secret.ory-authkeeper-issuer-secret.metadata[0].name
          }
        }
      }
    }
  }
}
