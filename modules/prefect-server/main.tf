resource "helm_release" "prefect-server" {
  name      = "prefect-server"
  namespace = var.namespace

  dependency_update = true
  repository = "https://prefecthq.github.io/server/"
  chart = "prefect-server"
  version = "2021.03.10"

  set {
    name = "jobs.createTenant.enabled"
    value = "true"
  }

  set {
    name  = "agent.enabled"
    value = var.agent_enabled
  }

  set {
    name  = "agent.image.name"
    value = var.agent_image_name
  }

  set {
    name  = "agent.image.tag"
    value = var.agent_image_tag
  }

  set {
    name  = "agent.image.pullPolicy"
    value = var.agent_image_pull_policy
  }

  set {
    name  = "prefectVersionTag"
    value = var.prefect_version_tag
  }

  set {
    name  = "postgresql.postgresqlDatabase"
    value = var.postgresql_database
  }

  set {
    name  = "postgresql.postgresqlUsername"
    value = var.postgresql_username
  }

  set {
    name  = "postgresql.existingSecret"
    value = var.postgresql_existing_secret
  }

  set {
    name  = "postgresql.servicePort"
    value = var.postgresql_service_port
  }

  set {
    name  = "postgresql.externalHostname"
    value = var.postgresql_external_hostname
  }

  set {
    name  = "postgresql.useSubchart"
    value = var.postgresql_use_subchart
  }

  set {
    name  = "postgresql.persistence.enabled"
    value = var.postgresql_persistence_enabled
  }

  set {
    name  = "postgresql.persistence.size"
    value = var.postgresql_persistence_size
  }

  set {
    name  = "postgresql.initdbUser"
    value = var.postgresql_init_user
  }

  set {
    name = "ui.apolloApiUrl"
    value = "${var.protocol}://prefect.${var.hostname}/graphql/"
  }

  set {
    name = "apollo.service.type"
    value = var.service_type
  }

  set {
    name = "ui.service.type"
    value = var.service_type
  }

  set {
    name = "serviceAccount.name"
    value = var.service_account_name
  }

  values = [
    yamlencode({
      "annotations" = var.annotations
    }),

    yamlencode({
      "agent" = {
        "prefectLabels" = var.agent_prefect_labels
      }
    }),
  ]
}

resource "kubernetes_cluster_role_binding" "seldon_prefect_crb" {
  count = var.seldon_manager_cluster_role_name != "" ? 1 : 0

  metadata {
    name = "prefect-seldon-rolebinding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = var.seldon_manager_cluster_role_name
  }
  subject {
    kind = "ServiceAccount"
    name = var.service_account_name
    namespace = var.namespace
  }
}