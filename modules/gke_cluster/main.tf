# modules/compute_instance/main.tf
resource "google_compute_instance" "default" {
  project      = var.project_id
  zone         = var.zone
  name         = "${var.instance_name}-${var.environment}"
  machine_type = var.machine_type
  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  network_interface {
    network = var.network
    subnetwork = var.subnetwork
    access_config { # This block is for external IP, remove if not needed
      // Ephemeral external IP
    }
  }
  tags = var.tags
  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  metadata = var.metadata # For startup scripts etc.

  labels = merge(var.labels, {
    environment = var.environment
  })
}

output "instance_self_link" {
  description = "The URI of the instance."
  value       = google_compute_instance.default.self_link
}

output "instance_ip_address" {
  description = "The external IP address of the instance."
  value       = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}