module "ory-oathkeeper" {
  source = "./oathkeeper"
  namespace = var.namespace

  hostname = var.hostname
  protocol = var.protocol
  enable_registration = var.enable_registration
  enable_keto = var.install_ory_keto
}

module "ory-kratos" {
  source = "./kratos"
  namespace = var.namespace

  cookie_secret = var.cookie_secret
  cookie_domain = var.hostname
  db_password = var.kratos_db_password
  oauth2_providers = var.oauth2_providers

  app_url = "${var.protocol}://${var.hostname}"
}

module "ory-keto" {
  count = var.install_ory_keto ? 1 : 0

  source = "./keto"
  namespace = var.namespace

  db_password = var.keto_db_password
  hostname = var.hostname
}