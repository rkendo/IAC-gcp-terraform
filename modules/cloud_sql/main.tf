# modules/cloud_sql/main.tf
resource "google_sql_database_instance" "default" {
  project             = var.project_id
  name                = "${var.instance_name}-${var.environment}"
  database_version    = var.database_version
  region              = var.region
  settings {
    tier = var.tier
    ip_configuration {
      ipv4_enabled  = var.ipv4_enabled
      private_network = var.private_network_self_link # Required for private IP
      authorized_networks {
        value = var.authorized_network_cidr
      }
    }
    backup_configuration {
      enabled            = var.backup_enabled
      start_time         = var.backup_start_time
      binary_log_enabled = var.binary_log_enabled
    }
    database_flags {
      name  = "cloudsql.iam_authentication" # Example: Enable IAM database authentication
      value = "On"
    }
    disk_autoresize     = true
    disk_size           = var.disk_size
    disk_type           = var.disk_type
    availability_type   = var.availability_type # REGIONAL for HA, ZONAL for single zone
  }

  deletion_protection_enabled = var.deletion_protection_enabled # Highly recommended for prod

  labels = merge(var.labels, {
    environment = var.environment
  })
}

resource "google_sql_database" "default_db" {
  instance = google_sql_database_instance.default.name
  name     = "${var.database_name}-${var.environment}"
  charset  = var.database_charset
  collation = var.database_collation
}

resource "google_sql_user" "default_user" {
  instance = google_sql_database_instance.default.name
  name     = var.db_user_name
  host     = var.db_user_host
  password = var.db_user_password # Consider using Secret Manager for production passwords
}

output "sql_instance_connection_name" {
  description = "The connection name of the SQL instance."
  value       = google_sql_database_instance.default.connection_name
}

output "sql_database_name" {
  description = "The name of the created database."
  value       = google_sql_database.default_db.name
}