resource "helm_release" "ambassador" {
  count = var.ambassador_enabled ? 1 : 0
  repository = "https://www.getambassador.io"
  chart = "ambassador"
  name = "ambassador"
  version = "1.13.10"
  namespace = var.namespace

  values = [templatefile("${path.module}/values.yaml", {
    tls_certificate_arn = var.tls_certificate_arn,
    aws = var.aws
    hostname = var.hostname
    tls = var.tls
    enable_ory_authentication = var.enable_ory_authentication
  })]
  set {
    name = "image.repository"
    value = "docker.io/datawire/ambassador"
  }
  set {
    name = "image.tag"
    value = "1.11.0"
  }
  set {
    name = "enableAES"
    value = "false"
  }
}