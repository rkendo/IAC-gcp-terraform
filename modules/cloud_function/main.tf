# modules/cloud_storage/main.tf
resource "google_storage_bucket" "default" {
  project                     = var.project_id
  name                        = "${var.bucket_name}-${var.environment}"
  location                    = var.location
  uniform_bucket_level_access = var.uniform_bucket_level_access
  force_destroy               = var.force_destroy # Be careful with this in production!

  versioning {
    enabled = var.versioning_enabled
  }

  lifecycle_rule {
    condition {
      age = var.lifecycle_age
    }
    action {
      type = "Delete"
    }
  }

  labels = merge(var.labels, {
    environment = var.environment
  })
}

output "bucket_name" {
  description = "The name of the Cloud Storage bucket."
  value       = google_storage_bucket.default.name
}

output "bucket_self_link" {
  description = "The self_link of the Cloud Storage bucket."
  value       = google_storage_bucket.default.self_link
}