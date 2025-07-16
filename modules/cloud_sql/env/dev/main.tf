# environments/dev/main.tf
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

# --- Common Service Account for all components in Dev ---
module "common_service_account_dev" {
  source      = "../../modules/iam"
  project_id  = var.gcp_project_id
  environment = var.environment_name
  sa_name     = "dev-app-sa"
  sa_display_name = "Dev Application Service Account"
  project_roles = [
    "roles/viewer",
    "roles/storage.objectAdmin",
    "roles/cloudfunctions.developer",
    "roles/container.developer",
    "roles/cloudsql.client",
    "roles/compute.viewer"
  ]
}

# --- VPC Network for Dev ---
module "dev_vpc" {
  source       = "../../modules/vpc"
  project_id   = var.gcp_project_id
  network_name = "dev-network"
  environment  = var.environment_name
  subnetworks = [
    {
      name                     = "dev-subnet-main"
      ip_cidr_range            = "10.0.0.0/20"
      region                   = var.gcp_region
      private_ip_google_access = true
      secondary_ip_ranges      = [
        {
          range_name    = "gke-pods-range"
          ip_cidr_range = "10.1.0.0/16"
        },
        {
          range_name    = "gke-services-range"
          ip_cidr_range = "10.2.0.0/20"
        }
      ]
    }
  ]
  labels = {
    team = "devops"
  }
}

# --- Compute Instance in Dev ---
module "dev_compute_instance" {
  source                  = "../../modules/compute_instance"
  project_id              = var.gcp_project_id
  zone                    = var.gcp_zone
  instance_name           = "dev-webserver"
  environment             = var.environment_name
  machine_type            = "e2-small"
  network                 = module.dev_vpc.network_self_link
  subnetwork              = module.dev_vpc.subnetworks_self_links["dev-subnet-main"]
  service_account_email   = module.common_service_account_dev.service_account_email
  tags                    = ["http-server", "ssh"]
  metadata = {
    startup-script = "#! /bin/bash\nsudo apt-get update\nsudo apt-get install -y nginx\necho \"Hello from Dev Webserver!\" | sudo tee /var/www/html/index.nginx-debian.html"
  }
}

# --- GKE Cluster in Dev ---
module "dev_gke_cluster" {
  source                      = "../../modules/gke_cluster"
  project_id                  = var.gcp_project_id
  zone                        = var.gcp_zone
  cluster_name                = "dev-gke"
  environment                 = var.environment_name
  initial_node_count          = 1
  node_count                  = 1
  min_node_count              = 1
  max_node_count              = 3
  node_machine_type           = "e2-medium"
  network_self_link           = module.dev_vpc.network_self_link
  subnetwork_self_link        = module.dev_vpc.subnetworks_self_links["dev-subnet-main"]
  cluster_secondary_range_name  = "gke-pods-range"
  services_secondary_range_name = "gke-services-range"
  enable_private_nodes        = true
  enable_private_endpoint     = true
  node_service_account_email  = module.common_service_account_dev.service_account_email
}

# --- Cloud Function in Dev (HTTP Triggered) ---
module "dev_http_cloud_function" {
  source                  = "../../modules/cloud_function"
  project_id              = var.gcp_project_id
  region                  = var.gcp_region
  function_name           = "dev-hello-world-http"
  environment             = var.environment_name
  runtime                 = "nodejs16" # Ensure you have a 'function-source.zip' in root
  entry_point             = "helloHttp"
  source_archive_path     = "./function-source.zip" # Create this file manually or via a build process
  memory                  = 128
  service_account_email   = module.common_service_account_dev.service_account_email
  enable_http_trigger_public_access = true # For easy testing
  labels = {
    function_type = "http"
  }
}

# --- Cloud Storage Bucket in Dev ---
module "dev_storage_bucket" {
  source                    = "../../modules/cloud_storage"
  project_id                = var.gcp_project_id
  bucket_name               = "dev-app-data"
  environment               = var.environment_name
  location                  = var.gcp_region
  uniform_bucket_level_access = true
  versioning_enabled        = true
  lifecycle_age             = 7 # Delete objects older than 7 days
}

# --- Cloud SQL Instance in Dev ---
module "dev_cloud_sql" {
  source                       = "../../modules/cloud_sql"
  project_id                   = var.gcp_project_id
  instance_name                = "dev-app-db"
  environment                  = var.environment_name
  database_version             = "POSTGRES_14"
  region                       = var.gcp_region
  tier                         = "db-f1-micro"
  ipv4_enabled                 = false
  private_network_self_link    = module.dev_vpc.network_self_link
  authorized_network_cidr      = "0.0.0.0/0" # This only applies if ipv4_enabled is true
  backup_enabled               = true
  backup_start_time            = "03:00"
  disk_size                    = 10
  disk_type                    = "PD_SSD"
  availability_type            = "ZONAL" # Not HA for dev
  deletion_protection_enabled  = false # Can delete easily in dev
  database_name                = "dev_main_db"
  db_user_name                 = "dev_user"
  db_user_password             = "your_dev_password" # In real-world, use Secret Manager
}