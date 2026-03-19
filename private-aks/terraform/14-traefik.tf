resource "kubernetes_namespace_v1" "traefik_namespace" {
  metadata {
    name = "traefik"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  version    = "32.1.0"  # pin to a specific version
  namespace  = kubernetes_namespace_v1.traefik_namespace.metadata[0].name
  wait              = true
  timeout           = 1900
  atomic            = true
  cleanup_on_fail   = true
  dependency_update = true

  # ✅ Correct — list with templatefile
  values = [
    templatefile("${path.module}/values/traefik-values.yaml", {
      replica_count = "1"
      environment   = local.env
    })
  ]

  set = [
    {
      name  = "dashboard.enabled"
      value = "true"
    },
    {
      name  = "service.type"
      value = "LoadBalancer"
    },
    {
      name  = "logs.access.enabled"
      value = "true"
    }
  ]

  depends_on = [
    kubernetes_namespace_v1.traefik_namespace,
    azurerm_kubernetes_cluster.aks_cluster_backend
  ]
}