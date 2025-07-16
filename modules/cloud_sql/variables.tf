# modules/cloud_sql/variables.tf
variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "instance_name" {
  description = "The base name for the Cloud SQL instance."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "database_version" {
  description = "The database version (e.g., POSTGRES_14, MYSQL_8_0)."
  type        = string
}

variable "region" {
  description = "The GCP region for the Cloud SQL instance."
  type        = string
}

variable "tier" {
  description = "The machine type tier (e.g., db-f1-micro, db-g1-small)."
  type        = string
}

variable "ipv4_enabled" {
  description = "Whether the instance is assigned a public IP address."
  type        = bool
  default     = false
}

variable "private_network_self_link" {
  description = "The self_link of the VPC network for private IP connectivity."
  type        = string
  default     = null # Set to null if ipv4_enabled is true
}

variable "authorized_network_cidr" {
  description = "CIDR range of networks authorized to connect to the instance (if public IP is enabled)."
  type        = string
  default     = "0.0.0.0/0" # Be careful with this in production!
}

variable "backup_enabled" {
  description = "Whether automated backups are enabled."
  type        = bool
  default     = true
}

variable "backup_start_time" {
  description = "The start time of the daily backup window in HH:MM format."
  type        = string
  default     = "03:00"
}

variable "binary_log_enabled" {
  description = "Whether binary log is enabled (required for point-in-time recovery)."
  type        = bool
  default     = true
}

variable "disk_size" {
  description = "The disk size for the Cloud SQL instance in GB."
  type        = number
  default     = 20
}

variable "disk_type" {
  description = "The disk type for the Cloud SQL instance (PD_SSD or PD_HDD)."
  type        = string
  default     = "PD_SSD"
}

variable "availability_type" {
  description = "The availability type for the Cloud SQL instance (ZONAL or REGIONAL for HA)."
  type        = string
  default     = "ZONAL"
}

variable "deletion_protection_enabled" {
  description = "Whether deletion protection is enabled for the instance."
  type        = bool
  default     = true
}

variable "database_name" {
  description = "The name of the default database to create."
  type        = string
  default     = "app_db"
}

variable "database_charset" {
  description = "The character set for the database."
  type        = string
  default     = "UTF8"
}

variable "database_collation" {
  description = "The collation for the database."
  type        = string
  default     = "en_US.UTF8"
}

variable "db_user_name" {
  description = "The name of the database user."
  type        = string
  default     = "app_user"
}

variable "db_user_host" {
  description = "The host from which the user can connect (e.g., '%', 'localhost')."
  type        = string
  default     = "%"
}

variable "db_user_password" {
  description = "The password for the database user. **Highly recommend using Secret Manager for production.**"
  type        = string
  sensitive   = true # Mark as sensitive to prevent showing in logs
}

variable "labels" {
  description = "Additional labels for the Cloud SQL instance."
  type        = map(string)
  default     = {}
}