# Followed this guide but with external-dns and cert-manager:
# https://mike.sg/2021/08/31/digitalocean-kubernetes-without-a-load-balancer/

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
  name             = "nginx-ingress-controller"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "nginx-ingress-controller"
  version          = "9.1.5"
  namespace        = "nginx"
  create_namespace = true
  values = [
    file("helm-values/nginx-ingress.yaml")
  ]
  timeout = 600
}

# https://www.digitalocean.com/community/tutorials/how-to-automatically-manage-dns-records-from-digitalocean-kubernetes-using-externaldns
resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  version          = "6.1.4"
  namespace        = "external-dns"
  create_namespace = true
  values = [
    file("helm-values/external-dns.yaml")
  ]
  set_sensitive {
    name  = "digitalocean.apiToken"
    value = var.digitalocean_token
  }
}

# https://cert-manager.io/docs/installation/helm/
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.7.1"
  namespace        = "cert-manager"
  create_namespace = true
  values = [
    file("helm-values/cert-manager.yaml")
  ]
}

# https://cert-manager.io/docs/tutorials/acme/nginx-ingress/#step-6-configure-let-s-encrypt-issuer
resource "kubernetes_manifest" "letsencrypt_staging_issuer" {
  manifest = yamldecode(file("kubernetes-manifests/letsencrypt-staging-issuer.yaml"))
}

resource "kubernetes_manifest" "letsencrypt_prod_issuer" {
  manifest = yamldecode(file("kubernetes-manifests/letsencrypt-prod-issuer.yaml"))
}
