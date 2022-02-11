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
  name         = local.deployment_name
  region       = var.digitalocean_region
  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.this.latest_version
  node_pool {
    name       = "default"
    size       = var.kubernetes_node_size
    node_count = var.kubernetes_node_count
  }
}

locals {
  k8s_host                   = digitalocean_kubernetes_cluster.this.endpoint
  k8s_token                  = digitalocean_kubernetes_cluster.this.kube_config.0.token
  k8s_cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
}

provider "kubernetes" {
  host                   = local.k8s_host
  token                  = local.k8s_token
  cluster_ca_certificate = local.k8s_cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = local.k8s_host
    token                  = local.k8s_token
    cluster_ca_certificate = local.k8s_cluster_ca_certificate
  }
}
