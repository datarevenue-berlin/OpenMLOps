data "template_file" "oauth2-proxy_values" {
  template = file("${path.module}/templates/oauth2-proxy.yaml")
  vars = {
    oauth_image_repository = var.oauth_image_repository
    oauth_image_tag        = var.oauth_image_tag

    oauth_client_id     = var.oauth_client_id
    oauth_client_secret = var.oauth_client_secret
    oauth_provider      = var.oauth_provider

    oauth_cookie_secret = var.oauth_cookie_secret
    oauth_cookie_expire = var.oauth_cookie_expire

    redirect_url = var.redirect_url
    domain = var.domain
  }
}

resource "helm_release" "oauth2-proxy" {
  name          = "oauth2-proxy"
  repository    = "https://k8s-at-home.com/charts/"
  chart         = "oauth2-proxy"
  version       = var.oauth_helm_chart_version
  namespace     = var.namespace
  recreate_pods = "true"

  values = [
    data.template_file.oauth2-proxy_values.rendered
  ]
}
