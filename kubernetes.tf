variable "environment_name" {
  description = "Name of the environment the cluster is for"
  type        = string
  default     = "dev"
}

# Look up slug identifiers here: https://slugs.do-api.dev/
variable "digitalocean_region" {
  description = "Slug identifier for the DigitalOcean region to deploy to"
  type        = string
  default     = "lon1"
}
variable "kubernetes_node_size" {
  description = "Slug identifier for the DigitalOcean droplet size to use for Kubernetes nodes"
  type        = string
  default     = "s-1vcpu-2gb"
}
variable "kubernetes_node_count" {
  description = "Number of nodes in the Kubernetes cluster"
  type        = number
  default     = 1
}

data "digitalocean_kubernetes_versions" "this" {
  version_prefix = "1.21."
}

resource "digitalocean_kubernetes_cluster" "this" {
  name         = "nisei-cloud-${var.environment_name}"
  region       = var.digitalocean_region
  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.this.latest_version
  node_pool {
    name       = "default"
    size       = var.kubernetes_node_size
    node_count = var.kubernetes_node_count
  }
}
