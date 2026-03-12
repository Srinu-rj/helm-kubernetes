
resource "kubernetes_namespace_v1" "kong_namespace" {
  metadata {
    name = "kong"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

# TODO ─── Kong Ingress Controller (via Helm) ───────────────────────────────────────
resource "helm_release" "kong" {
  name              = "kong"
  repository        = "https://charts.konghq.com"
  chart             = "ingress"
  version           = "0.12.0"
  namespace         = kubernetes_namespace_v1.kong_namespace.metadata[0].name
  wait              = true
  timeout           = 1900
  atomic            = true
  cleanup_on_fail   = true
  dependency_update = true

  set = [
    {
      name  = "controller.ingressController.enabled"
      value = "true"
    },
    {
      name  = "controller.ingressController.installCRDs"
      value = "false"
    },
    {
      name  = "proxy.type"
      value = "LoadBalancer"
    },
    {
      name  = "replicaCount"
      value = "2"
    },
    {
      name  = "admin.enabled"
      value = "false"
    },
    {
      name  = "admin.type"
      value = "ClusterIP"
    },
    {
      name  = "serviceMonitor.enabled"
      value = "false"
    },
    {
      name  = "resources.requests.cpu"
      value = "100m"
    },
    {
      name  = "resources.requests.memory"
      value = "256Mi"
    },
    {
      name  = "resources.limits.cpu"
      value = "500m"
    },
    {
      name  = "resources.limits.memory"
      value = "512Mi"
    }

  ]


  depends_on = [
    kubernetes_namespace_v1.keda_namespace,
    azurerm_kubernetes_cluster.aks_cluster_backend
  ]
}
