resouce "google_compute_network" "vpc_network" {
    project   = var.project_id
    name      = "${var.network_name}-${var.environment}"
    auto_create_subnetworks = false
    routing_mode = var.routing_mode
    
    labels = merge(var.lables,{
        environment = var.environment
    })
resource "google_compute_subnetwork" "vpc_subnetwork" {
  for_each      = { for s in var.subnetworks : s.name => s }
  project       = var.project_id
  name          = "${each.value.name}-${var.environment}"
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = google_compute_network.vpc_network.self_link
  private_ip_google_access = each.value.private_ip_google_access

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  labels = merge(var.labels, {
    environment = var.environment
  })
}

output "network_self_link" {
  description = "The self link of the VPC network."
  value       = google_compute_network.vpc_network.self_link
}

output "subnetworks_self_links" {
  description = "Map of subnetwork names to their self links."
  value       = { for k, v in google_compute_subnetwork.vpc_subnetwork : k => v.self_link }
}
}