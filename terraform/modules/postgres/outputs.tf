output "db_host" {
  value = "${helm_release.postgres.name}-postgresql.${helm_release.postgres.namespace}.svc.cluster.local"
}