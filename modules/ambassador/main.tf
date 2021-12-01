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
  repository = "https://app.getambassador.io"
  chart = "emissary-ingress"
  name = "emissary-ingress"
  version = "7.1.10"
  namespace = var.namespace

  values = [data.template_file.ambassador-chart-values.rendered]
  set {
    name = "image.repository"
    value = "docker.io/emissaryingress/emissary"
  }
  set {
    name = "image.tag"
    value = "2.0.5"
  }
  set {
    name = "enableAES"
    value = "false"
  }
  set {
    name = "createDefaultListeners"
    value = "true"
  }
}