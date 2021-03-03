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

data template_file "oidc-providers" {
  template = file("${path.module}/oidc_providers.json.tmpl")

  count = length(var.oauth2_providers)
  vars = {
    provider = var.oauth2_providers[count.index].provider
    client_id = var.oauth2_providers[count.index].client_id
    client_secret = var.oauth2_providers[count.index].client_secret
    tenant = var.oauth2_providers[count.index].tenant
    mapper_url = local.provider_paths[var.oauth2_providers[count.index].provider]
    scope = join(",", local.scopes[var.oauth2_providers[count.index].provider])
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
    file("${path.module}/values.yaml")
  ]
  set {
    name = "kratos.config.dsn"
    value = "postgres://${var.db_username}:${var.db_password}@${module.kratos-postgres.db_host}:5432/${var.database_name}"
  }
  set {
    name = "kratos.config.selfservice.default_browser_return_url"
    value = local.dashboard_url
  }
  set {
    name = "kratos.config.selfservice.whitelisted_return_urls"
    value = yamlencode(list(var.domain))
  }
  set {
    name = "kratos.config.selfservice.flows.logout.after.default_browser_return_url"
    value = local.login_url
  }
  set {
    name = "kratos.config.selfservice.flows.settings.ui_url"
    value = local.settings_url
  }
  set {
    name = "kratos.config.selfservice.flows.verification.ui_url"
    value = local.verify_url
  }
  set {
    name = "kratos.config.selfservice.flows.login.ui_url"
    value = local.login_url
  }
  set {
    name = "kratos.config.selfservice.flows.error.ui_url"
    value = local.error_url
  }
  set {
    name = "kratos.config.selfservice.flows.registration.ui_url"
    value = local.registration_url
  }
  set {
    name = "kratos.config.serve.public.base_url"
    value = local.api_url
  }
  set {
    name = "kratos.config.serve.public.port"
    value = 4433
  }
  set {
    name = "kratos.config.secrets.cookie"
    value = yamlencode(list(var.cookie-secret))
  }
  set {
    name = "kratos.config.selfservice.methods.oidc.config.providers"
    value = yamlencode(jsondecode(join(",", data.template_file.oidc-providers.*.rendered)))
  }
  # TODO: Make terraform render these schemas properly
//  set {
//    name = "kratos.identitySchemas"
//    value = yamlencode(local.identity_schemas)
//  }

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
  namespace = "ory"

  database_name = var.database_name
  db_username = var.db_username
  db_password = var.db_password
}