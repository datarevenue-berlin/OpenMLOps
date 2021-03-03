output "oidc_providers_rendered" {
  value = yamlencode(jsondecode(join(",", data.template_file.oidc-providers.*.rendered)))
}