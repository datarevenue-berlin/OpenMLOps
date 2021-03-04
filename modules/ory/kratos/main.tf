locals {
  ui_deployment_name = "ory-kratos-ui"
  ui_url = "${var.domain}/"
  dashboard_url = "${var.domain}/dashboard"
  registration_url = "${var.domain}/auth/registration"
  login_url = "${var.domain}/auth/login"
  settings_url = "${var.domain}/settings"
  verify_url = "${var.domain}/verify"
  error_url = "${var.domain}/error"
  api_url = "${var.domain}/.ory/kratos/public"

  provider_paths = {
    "github" = "file:///etc/config/oidc.github.jsonnet"
    "google" = "file:///etc/config/oidc.github.jsonnet"
    "microsoft" = "file:///etc/config/oidc.github.jsonnet"
  }
  schemas_path = "${path.module}/schemas"
  scopes = {
    "github" = ["user:email"]
    "google" = ["user:email"]
    "microsoft" = ["profile", "email"]
  }

  identity_schemas = {
    "identity.traits.schema.json" = file("${local.schemas_path}/identity.traits.schema.json")
    "oidc.github.jsonnet" = file("${local.schemas_path}/oidc.github.jsonnet")
    "oidc.microsoft.jsonnet" = file("${local.schemas_path}/oidc.microsoft.jsonnet")
  }
}

resource "helm_release" "ory-kratos" {
  name = "ory-kratos"
  namespace = var.namespace
  depends_on = [
    module.kratos-postgres]
  repository = "https://k8s.ory.sh/helm/charts"
  chart = "kratos"

  values = [
    templatefile("${path.module}/values.yaml", {
      dsn = "postgres://${var.db_username}:${urlencode(var.db_password)}@${module.kratos-postgres.db_host}:5432/${var.database_name}",
      domain = var.domain,
      oidc_providers_config = templatefile("${path.module}/oidc_providers.yaml.tmpl", {
        oauth2_providers = var.oauth2_providers
        provider_paths = local.provider_paths
        scopes = local.scopes
      })
      cookie_secret = var.cookie_secret,
    })
  ]
  # TODO: Make terraform render these schemas properly

}

resource "kubernetes_deployment" "ory-kratos-ui" {
  metadata {
    name = "ory-kratos-ui"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "ory-kratos-ui"
      }
    }
    strategy {
      type = "RollingUpdate"
    }
    template {
      metadata {
        labels = {
          app = "ory-kratos-ui"
        }
      }
      spec {
        container {
          name = "ory-kratos-ui"
          image = "oryd/kratos-selfservice-ui-node:v0.5.0-alpha.1"
          env {
            name = "KRATOS_PUBLIC_URL"
            value = "http://${helm_release.ory-kratos.name}-public.${var.namespace}.svc.cluster.local:80"
          }
          env {
            name = "KRATOS_ADMIN_URL"
            value = "http://${helm_release.ory-kratos.name}-admin.${var.namespace}.svc.cluster.local:80"
          }
          env {
            name = "SECURITY_MODE"
            value = "jwks"
          }
          env {
            name = "JWKS_URL"
            value = "http://ory-oathkeeper.ory.svc.cluster.local:80/.well-known/jwks.json"
          }
          env {
            name = "KRATOS_BROWSER_URL"
            value = local.api_url
          }
          env {
            name = "PORT"
            value = "4455"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ory-kratos-ui" {
  metadata {
    name = "ory-kratos-ui"
    namespace = var.namespace
    annotations = {
      "getambassador.io/config" = <<YAML
---
apiVersion: getambassador.io/v2
kind: Mapping
name: ory-kratos-ui_mapping
service: ory-kratos-ui.ory
prefix: /
YAML
    }
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = "ory-kratos-ui"
    }
    port {
      port = 80
      name = "http-ory-kratos-ui"
      target_port = 4455
    }
  }
}

module "kratos-postgres" {
  source = "../../postgres"
  namespace = var.namespace

  database_name = var.database_name
  db_username = var.db_username
  db_password = var.db_password
}
output "db_connection_string" {
  value = "postgres://${var.db_username}:${urlencode(var.db_password)}@${module.kratos-postgres.db_host}:5432/${var.database_name}"
}