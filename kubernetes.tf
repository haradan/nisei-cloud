variable "environment_name" {
  description = "Name of the environment the cluster is for"
  type        = string
}

variable "digitalocean_region" {
  description = "Slug identifier for the DigitalOcean region to deploy to"
  type        = string
  default     = "lon1"
}

data "digitalocean_kubernetes_versions" "this" {
  version_prefix = "1.21."
}

data "digitalocean_sizes" "this" {
  filter {
    key    = "regions"
    values = [var.digitalocean_region]
  }
  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}

resource "digitalocean_kubernetes_cluster" "this" {
  name         = "nisei-cloud-${var.environment_name}"
  region       = var.digitalocean_region
  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.this.latest_version
  node_pool {
    name       = "default"
    size       = element(data.digitalocean_sizes.this.sizes, 0).slug
    node_count = 1
  }
}

output "available_sizes" {
  value = jsonencode(data.digitalocean_sizes.this.sizes)
}
