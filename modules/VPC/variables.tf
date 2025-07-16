# modules/vpc/variables.tf
variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "network_name" {
  description = "The base name for the VPC network."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "routing_mode" {
  description = "The routing mode for the network (GLOBAL or REGIONAL)."
  type        = string
  default     = "REGIONAL"
}

variable "subnetworks" {
  description = "List of subnetwork configurations."
  type = list(object({
    name                     = string
    ip_cidr_range            = string
    region                   = string
    private_ip_google_access = bool
    secondary_ip_ranges      = list(object({
      range_name    = string
      ip_cidr_range = string
    }))
  }))
}

variable "labels" {
  description = "Additional labels for the VPC and subnetworks."
  type        = map(string)
  default     = {}
}