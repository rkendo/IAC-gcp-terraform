resouce "google_container_cluster" "cluster1" {
    project    = var.project_id
    location   = var.zone
    name       = "${var.cluster_name}-${var.environment}"
    initial_node_count = var.initial_node_count
    node_locations  = var.node_locations
    remove_default_node_pool = true

    network = var.network
    subnetwork = var.subnetwork

    ip_allocation_policy {
        cluster_secondary_range_name   = var. cluster_secondary_range_name
        services_secondary_range_name   = var. services_secondary_range_name_secondary_range_name
    }
}