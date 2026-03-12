resource "kubernetes_namespace_v1" "ha_proxy_namespace" {
  metadata {
    name = "haproxy-controller"
    labels = {
      "managed-by" = "terraform"
    }
  }
}

resource "helm_release" "haproxy" {
  name       = "haproxy-ingress"
  repository = "https://haproxy-ingress.github.io/charts"
  chart      = "haproxy-ingress"
  version    = "0.15.0"
  namespace  = kubernetes_namespace_v1.ha_proxy_namespace.metadata[0].name
  wait             = true
  timeout          = 1800
  atomic           = true
  cleanup_on_fail  = true
  dependency_update = true


  set = [

    {
      name  = "controller.replicaCount"
      value = "2"
      type  = "auto"
    },
    {
      name  = "controller.minAvailable"
      value = "1"
      type  = "auto"
    },
    {
      name  = "controller.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "controller.stats.enabled"
      value = "true"
      type  = "auto"
    },
    {
      name  = "controller.metrics.enabled"
      value = "true"
      type  = "auto"
    }
  ]

  depends_on = [
    kubernetes_namespace_v1.ha_proxy_namespace,
    azurerm_kubernetes_cluster.aks_cluster_backend
  ]
}
