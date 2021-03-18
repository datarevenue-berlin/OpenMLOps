variable "hostname" {
  description = "Application hostname ex.: mlops.mywebsite.com"
}

variable "protocol" {
  description = "Preferred connection protocol"
}

variable "parent_module_name" {
  description = "Name of the calling module. Needed for a hack of downloading the Helm chart."
  type = string
}

variable "namespace" {
  description = "Namespace name to deploy the application"
  default     = "default"
}

variable "prefect_version_tag" {
  description = "Configures the default tag for prefect images"
  default     = "latest"
}

variable "annotations" {
  description = "Annotations to merge into all object configurations"
  default     = {}
}

variable "agent_enabled" {
  description = "determines if the Prefect Kubernetes agent is deployed"
  default     = true
}

variable "agent_prefect_labels" {
  description = "Defines what scheduling labels (not K8s labels) should be associated with the agent"
  default     = [""]
}

variable "agent_image_name" {
  description = "Defines the prefect agent image name"
  default     = "prefecthq/prefect"
}

variable "agent_image_tag" {
  description = "Defines agent image tag"
  default     = ""
}

variable "agent_image_pull_policy" {
  default = "Always"
}

variable "postgresql_database" {
  description = "Database name"
  default     = "prefect"
}

variable "postgresql_username" {
  description = "Defines the username to authenticate with"
  default     = "prefect"
}

variable "postgresql_existing_secret" {
  description = "Configures which secret should be referenced for access to the database."
  default     = ""
}

variable "postgresql_service_port" {
  description = "Configures the port that the database should be accessed at"
  default     = "5432"
}

variable "postgresql_external_hostname" {
  description = "Defines the address to contact an externally managed postgres database instance at"
  default     = ""
}

variable "postgresql_use_subchart" {
  description = "Determines if a this chart should deploy a user-manager postgres database or use an externally managed postgres instance"
  default     = true
}

variable "postgresql_persistence_enabled" {
  description = "Enables a PVC that stores the database between deployments. If making changes to the database deployment, this PVC will need to be deleted for database changes to take effect. This is especially notable when the authentication password changes on redeploys."
  default     = false
}

variable "postgresql_persistence_size" {
  default = "8Gi"
}

variable "postgresql_init_user" {
  default = "postgres"
}

variable "service_type" {
  description = "Whether to expose the service publicly or internally"
  default = "LoadBalancer"
  type = string
}