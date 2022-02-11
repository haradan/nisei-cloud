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

provider "helm" {
  kubernetes {
    host                   = digitalocean_kubernetes_cluster.this.endpoint
    client_certificate     = base64decode(digitalocean_kubernetes_cluster.this.kube_config.0.client_certificate)
    client_key             = base64decode(digitalocean_kubernetes_cluster.this.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
  }
}

resource "digitalocean_firewall" "kubernetes" {
  name = local.deployment_name
  tags = ["k8s:${digitalocean_kubernetes_cluster.this.id}"]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  version    = "9.1.5"
  values = [
    file("helm-values/nginx-ingress.yaml")
  ]
}
