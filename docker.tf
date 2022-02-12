resource "digitalocean_container_registry" "this" {
  name                   = local.deployment_name
  subscription_tier_slug = "starter"
}

resource "digitalocean_container_registry_docker_credentials" "this" {
  registry_name = digitalocean_container_registry.this.name
}

resource "kubernetes_secret" "docker_credentials" {
  metadata {
    name = "docker-cfg"
  }
  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.this.docker_credentials
  }
  type = "kubernetes.io/dockerconfigjson"
}
