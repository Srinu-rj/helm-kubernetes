resource "kubernetes_namespace_v1" "cert_manager_namespace" {
  metadata {
    name = "cert-manager"

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.14.4" # pin to a specific version
  namespace  = kubernetes_namespace_v1.cert_manager_namespace.metadata[0].name
  wait             = true
  timeout          = 1800
  atomic           = true
  cleanup_on_fail  = true
  dependency_update = true


  # Required: installs the CRDs (CertificateRequests, Issuers, etc.)
  set = [
    {
      name  = "installCRDs"
      value = "true"
    },
    # Optional but recommended
    {
      name  = "global.leaderElection.namespace"
      value = "cert-manager"
    }
  ]
  depends_on = [
    kubernetes_namespace_v1.cert_manager_namespace,
    azurerm_kubernetes_cluster.aks_cluster_backend
  ]

}

# resource "kubernetes_manifest" "letsencrypt_staging" {
#   depends_on = [helm_release.cert_manager]
#
#   manifest = {
#     apiVersion = "cert-manager.io/v1"
#     kind       = "ClusterIssuer"
#     metadata = {
#       name = "letsencrypt-staging"
#     }
#     spec = {
#       acme = {
#         server = "https://acme-staging-v02.api.letsencrypt.org/directory"
#         email  = "dnsrinu143@gmail.com" # ← change this
#         privateKeySecretRef = {
#           name = "letsencrypt-staging-key"
#         }
#         solvers = [{
#           http01 = {
#             ingress = {
#               class = "haproxy" # ← match your ingress class
#             }
#           }
#         }]
#       }
#     }
#   }
# }
