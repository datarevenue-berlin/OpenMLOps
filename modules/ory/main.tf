module "ory-oathkeeper" {
  source = "./oathkeeper"
  namespace = var.namespace

  hostname = var.hostname
  protocol = var.protocol
}

module "ory-kratos" {
  source = "./kratos"
  namespace = var.namespace

  cookie_secret = var.cookie_secret
  db_password = var.db_password
  oauth2_providers = var.oauth2_providers

  app_url = "${var.protocol}://${var.hostname}"
}