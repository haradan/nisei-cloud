resource "helm_release" "postgresql" {
  name       = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "11.0.2"
  values = [
    file("helm-values/postgresql.yaml")
  ]
}
