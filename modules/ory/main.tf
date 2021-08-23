module "ory-oathkeeper" {
  source = "./oathkeeper"
  namespace = var.namespace

  hostname = var.hostname
  protocol = var.protocol
  enable_registration = var.enable_registration

  access_rules_path = var.access_rules_path
}

module "ory-kratos" {
  source = "./kratos"
  namespace = var.namespace

  cookie_secret = var.cookie_secret
  cookie_domain = var.hostname
  db_password = var.kratos_db_password
  oauth2_providers = var.oauth2_providers
  enable_password_recovery = var.enable_password_recovery
  enable_verification = var.enable_verification
  smtp_connection_uri = var.smtp_connection_uri
  smtp_from_address = var.smtp_from_address

  app_url = "${var.protocol}://${var.hostname}"
}