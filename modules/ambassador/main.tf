data "template_file" "ambassador-chart-values"{
  template = file("%{if var.ambassador_chart_values_path == null}${path.module}/values.yaml%{else}${var.ambassador_chart_values_path}%{ endif }")
  vars = {
    tls_certificate_arn = var.tls_certificate_arn,
    aws = var.aws
    hostname = var.hostname
    tls = var.tls
    enable_ory_authentication = var.enable_ory_authentication
  }
}

resource "helm_release" "ambassador" {
  count = var.ambassador_enabled ? 1 : 0
  repository = "https://www.getambassador.io"
  chart = "ambassador"
  name = "ambassador"
  version = "6.7.13"
  namespace = var.namespace

  values = [data.template_file.ambassador-chart-values]
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