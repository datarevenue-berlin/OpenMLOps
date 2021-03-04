output "oidc_providers_rendered" {
  value =  join("\n", data.template_file.oidc-providers.*.rendered)
}