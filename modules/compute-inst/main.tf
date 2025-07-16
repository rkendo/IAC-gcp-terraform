resource "google_compute_instance" "instance_dev"{
    project = var.project
    zone    = var.zone
    name    = "${var.instance_name}-${var.environment}"
    machine_type = var.machine_type
    boot_disk{
        initialize_params{
            image  = var.image
        }
    }
    network_interface{
        network = var.network
        subnet  = var.subnet

    }
    tags = var.tags{
    service_accoun{
        email  = var.service_account_email
        scopes = var.service_account_scopes
    }
    metadata = var.metadata # For startup scripts etc

    labels = merge(var.labels, {
        environment = var.environment
    })
    }
}