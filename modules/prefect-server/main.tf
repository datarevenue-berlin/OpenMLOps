// This is a hack. We're just making Terraform download the Prefect repository. Then we refer to its location
// in helm_release resource. This is necessary until Prefect starts hosting its Helm chart in a Helm repository.
module "github-repo" {
  source = "git::https://github.com/PrefectHQ/server.git"
}

resource "helm_release" "prefect-server" {
  name      = "prefect-server"
  namespace = var.namespace

  dependency_update = true
  chart             = "${path.root}/.terraform/modules/${var.parent_module_name}.prefect-server.github-repo/helm/prefect-server"

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