variable "project" {
    description = "project_id"
    type        = string
}
variable "zone"{
    description = "gcp_zone"
    type        = string

}
variable "instance_name" {
    description = "instance_name"
    type        = string
}
variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
}
variable "machine_type" {
  description = "The machine type for the instance."
  type        = string
  default     = "e2-medium"
}

variable "image" {
  description = "The boot disk image for the instance."
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "network" {
  description = "The VPC network for the instance."
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork for the instance."
  type        = string
}
variable "tags"{
    description = "Network tags for the instance."
    type        = list(string)
    default     = []
}
variable "service_account_email" {
  description = "Email of the service account to attach to the instance."
  type        = string
}
variable "service_account_scopes" {
  description = "List of OAuth 2.0 scopes to assign to the service account."
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

variable "metadata" {
  description = "Metadata for the instance (e.g., startup-script)."
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Additional labels for the instance."
  type        = map(string)
  default     = {}
}