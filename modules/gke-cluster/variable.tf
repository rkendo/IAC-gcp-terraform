# modules/gke_cluster/variables.tf
variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "zone" {
  description = "The GCP zone for the GKE cluster."
  type        = string
}

variable "cluster_name" {
  description = "The base name for the GKE cluster."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "initial_node_count" {
  description = "The number of nodes in the cluster's default node pool."
  type        = number
  default     = 1
}

variable "node_locations" {
  description = "The list of Google Compute Engine zones where the cluster's nodes are located."
  type        = list(string)
  default     = []
}

variable "min_master_version" {
  description = "The minimum version for the master (e.g., '1.27.3-gke.100')."
  type        = string
  default     = "1.27.3-gke.100"
}

variable "network_self_link" {
  description = "The self_link of the VPC network where the GKE cluster will be created."
  type        = string
}

variable "subnetwork_self_link" {
  description = "The self_link of the subnetwork where the GKE cluster will be created."
  type        = string
}

variable "cluster_secondary_range_name" {
  description = "The name of the secondary IP range for the GKE cluster pods."
  type        = string
}

variable "services_secondary_range_name" {
  description = "The name of the secondary IP range for the GKE cluster services."
  type        = string
}

variable "enable_private_nodes" {
  description = "Whether the nodes are created as private nodes."
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Whether the master's internal IP address is exposed to users."
  type        = bool
  default     = true
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the master's private IP address."
  type        = string
  default     = "172.16.0.0/28"
}

variable "release_channel" {
  description = "The GKE release channel (e.g., REGULAR, STABLE, RAPID)."
  type        = string
  default     = "REGULAR"
}

variable "node_count" {
  description = "The number of nodes in the node pool."
  type        = number
  default     = 2
}

variable "node_machine_type" {
  description = "The machine type for the node pool."
  type        = string
  default     = "e2-medium"
}

variable "node_disk_size_gb" {
  description = "Size of the disk attached to each node, specified in GB."
  type        = number
  default     = 100
}

variable "node_image_type" {
  description = "The image type to use for the node pool."
  type        = string
  default     = "COS" # Container-Optimized OS
}

variable "node_oauth_scopes" {
  description = "The set of Google API scopes to be made available on all of the node VMs."
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

variable "node_service_account_email" {
  description = "The service account to be used by the node VMs."
  type        = string
}

variable "min_node_count" {
  description = "Minimum number of nodes in the node pool for autoscaling."
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes in the node pool for autoscaling."
  type        = number
  default     = 5
}

variable "labels" {
  description = "Additional labels for the GKE cluster."
  type        = map(string)
  default     = {}
}