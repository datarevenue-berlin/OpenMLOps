//module "ory-oathkeeper" {
//  source = "./oathkeeper"
//  namespace = var.namespace
//
//  hostname = var.hostname
//  protocol = var.protocol
//}
//
//module "ory-kratos" {
//  source = "./kratos"
//  namespace = var.namespace
//
//  cookie_secret = var.cookie-secret
//  db_password = var.db_password
//  oauth2_providers = var.oauth2_providers
//
//  domain = "${var.protocol}://${var.hostname}"
//}