# modules/cloud_storage/variables.tf
variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "bucket_name" {
  description = "The base name for the Cloud Storage bucket."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "location" {
  description = "The location (region or multi-region) for the bucket."
  type        = string
  default     = "US"
}

variable "uniform_bucket_level_access" {
  description = "Enables uniform bucket-level access on the bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket."
  type        = bool
  default     = false
}

variable "lifecycle_age" {
  description = "Number of days after object creation to delete the object."
  type        = number
  default     = 30
}

variable "labels" {
  description = "Additional labels for the Cloud Storage bucket."
  type        = map(string)
  default     = {}
}