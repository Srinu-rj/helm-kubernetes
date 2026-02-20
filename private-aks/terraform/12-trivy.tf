
# resource "kubernetes_namespace_v1" "trivy" {
#   metadata {
#     name        = "my-namespace"
#     labels      = { tier = "frontend" }
#     annotations = { "description" = "Namespace for frontend services" }
#   }
# }
#
# resource "helm_release" "trivy_helm" {
#   name       = "trivy-helm"
#   namespace  = kubernetes_namespace_v1.trivy.metadata.0.name
#
#   repository = "https://aquasecurity.github.io/helm-charts/" # TODO witch repo you want to scan usisng trivy
#   chart      = "trivy-operator"
#
#
#   values = [
#     file("values.yaml")
#   ]
#
# }
