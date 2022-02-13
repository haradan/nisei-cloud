resource "random_password" "postgresql_admin_pwd" {
  length = 20
}

resource "helm_release" "postgresql" {
  name       = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "11.0.2"
  namespace  = "postgresql"
  values = [
    file("helm-values/postgresql.yaml")
  ]
  set {
    name  = "postgresqlPassword"
    value = random_password.postgresql_admin_pwd.result
  }
}

resource "kubernetes_namespace" "postgresql" {
  metadata {
    name = "postgresql"
  }
}

resource "kubernetes_secret" "postgresql_admin" {
  metadata {
    name      = "postgresql-admin"
    namespace = "postgresql"
  }
  data = {
    username = "postgres"
    password = random_password.postgresql_admin_pwd.result
  }
}
