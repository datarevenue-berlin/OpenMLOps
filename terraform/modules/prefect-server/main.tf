provider "helm" {}

module "prefect-server" {
  source = "git::https://github.com/PrefectHQ/server.git"
}

resource "helm_release" "prefect-server" {
  name      = "prefect-server"
  namespace = var.namespace

  dependency_update = true
  chart             = ".terraform/modules/prefect_server/helm/prefect-server"

  set {
    name  = "agent.enabled"
    value = "true"
  }

}