variable "namespace" {
    description = "Namespace name to deploy the application"
    default = "default"
}

variable "db_username" {
    description = "Postgress database username"
    default = "postgres"
}

variable "db_password" {
    description = "Postgress database password"
}

variable "database_name" {
    description = "Variable when running the image for the first time, a database will be created"
}   

variable "service_port" {
    description = "Service port number"
    default = 5432
}

