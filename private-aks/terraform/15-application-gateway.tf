# resource "kubernetes_namespace_v1" "gateway" {
#   metadata {
#     name = "gateway-system"
#     labels = {
#       "app.kubernetes.io/managed-by" = "terraform"
#     }
#   }
# }
#
# # -------------------------------------------------------------------
# # GatewayClass
# # Defines which controller handles Gateways of this class.
# # Using Envoy Gateway as the reference implementation.
# # -------------------------------------------------------------------
# resource "kubernetes_manifest" "gateway_class" {
#   manifest = {
#     apiVersion = "gateway.networking.k8s.io/v1"
#     kind       = "GatewayClass"
#
#     metadata = {
#       name = "envoy-gateway"
#       labels = {
#         "app.kubernetes.io/managed-by" = "terraform"
#       }
#     }
#
#     spec = {
#       controllerName = "gateway.envoyproxy.io/gatewayclass-controller"
#       description    = "Envoy-based Gateway implementation managed by Terraform"
#     }
#   }
# }
#
# # -------------------------------------------------------------------
# # Gateway
# # Represents the data-plane listener (HTTP + HTTPS).
# # -------------------------------------------------------------------
# resource "kubernetes_manifest" "gateway" {
#   depends_on = [kubernetes_manifest.gateway_class]
#
#   manifest = {
#     apiVersion = "gateway.networking.k8s.io/v1"
#     kind       = "Gateway"
#
#     metadata = {
#       name      = "main-gateway"
#       namespace = kubernetes_namespace_v1.gateway.metadata[0].name
#       labels = {
#         "app.kubernetes.io/managed-by" = "terraform"
#       }
#       annotations = {
#         "gateway.envoyproxy.io/log-level" = "info"
#       }
#     }
#
#     spec = {
#       gatewayClassName = kubernetes_manifest.gateway_class.manifest.metadata.name
#
#       listeners = [
#         {
#           name     = "http"
#           protocol = "HTTP"
#           port     = 80
#           allowedRoutes = {
#             namespaces = {
#               from = "Same"
#             }
#           }
#         },
#         {
#           name     = "https"
#           protocol = "HTTPS"
#           port     = 443
#           tls = {
#             mode = "Terminate"
#             certificateRefs = [
#               {
#                 kind      = "Secret"
#                 name      = kubernetes_secret.tls_cert.metadata[0].name
#                 namespace = kubernetes_namespace_v1.gateway.metadata[0].name
#               }
#             ]
#           }
#           allowedRoutes = {
#             namespaces = {
#               from = "Same"
#             }
#           }
#         }
#       ]
#     }
#   }
# }
#
# # -------------------------------------------------------------------
# # Self-signed TLS Secret (replace with a real cert in production)
# # -------------------------------------------------------------------
# resource "kubernetes_secret" "tls_cert" {
#   metadata {
#     name      = "gateway-tls-cert"
#     namespace = kubernetes_namespace_v1.gateway.metadata[0].name
#     labels = {
#       "app.kubernetes.io/managed-by" = "terraform"
#     }
#   }
#
#   type = "kubernetes.io/tls"
#
#   # Replace these with real base64-encoded certificate and key
#   data = {
#     "tls.crt" = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0t..." # base64 PEM cert
#     "tls.key" = "LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0t..." # base64 PEM key
#   }
# }
#
# # -------------------------------------------------------------------
# # Sample backend: Deployment + Service
# # -------------------------------------------------------------------
# resource "kubernetes_deployment" "app" {
#   metadata {
#     name      = "sample-app"
#     namespace = kubernetes_namespace_v1.gateway.metadata[0].name
#     labels = {
#       app                            = "sample-app"
#       "app.kubernetes.io/managed-by" = "terraform"
#     }
#   }
#
#   spec {
#     replicas = 2
#
#     selector {
#       match_labels = {
#         app = "sample-app"
#       }
#     }
#
#     template {
#       metadata {
#         labels = {
#           app = "sample-app"
#         }
#       }
#
#       spec {
#         container {
#           name  = "app"
#           image = "hashicorp/http-echo:latest"
#           args  = ["-text=Hello from Gateway API"]
#
#           port {
#             container_port = 5678
#           }
#
#           resources {
#             requests = {
#               cpu    = "50m"
#               memory = "64Mi"
#             }
#             limits = {
#               cpu    = "200m"
#               memory = "128Mi"
#             }
#           }
#         }
#       }
#     }
#   }
# }
#
# resource "kubernetes_service" "app" {
#   metadata {
#     name      = "sample-app"
#     namespace = kubernetes_namespace_v1.gateway.metadata[0].name
#     labels = {
#       app                            = "sample-app"
#       "app.kubernetes.io/managed-by" = "terraform"
#     }
#   }
#
#   spec {
#     selector = {
#       app = "sample-app"
#     }
#
#     port {
#       name        = "http"
#       port        = 80
#       target_port = 5678
#     }
#
#     type = "ClusterIP"
#   }
# }
#
# # -------------------------------------------------------------------
# # HTTPRoute
# # Routes traffic from the Gateway to backend services.
# # -------------------------------------------------------------------
# resource "kubernetes_manifest" "http_route" {
#   depends_on = [kubernetes_manifest.gateway]
#
#   manifest = {
#     apiVersion = "gateway.networking.k8s.io/v1"
#     kind       = "HTTPRoute"
#
#     metadata = {
#       name      = "sample-app-route"
#       namespace = kubernetes_namespace_v1.gateway.metadata[0].name
#       labels = {
#         "app.kubernetes.io/managed-by" = "terraform"
#       }
#     }
#
#     spec = {
#       parentRefs = [
#         {
#           name      = kubernetes_manifest.gateway.manifest.metadata.name
#           namespace = kubernetes_namespace_v1.gateway.metadata[0].name
#         }
#       ]
#
#       hostnames = ["app.example.com"]
#
#       rules = [
#         # --- /api/* → sample-app (with header injection) ---
#         {
#           matches = [
#             {
#               path = {
#                 type  = "PathPrefix"
#                 value = "/api"
#               }
#             }
#           ]
#
#           filters = [
#             {
#               type = "RequestHeaderModifier"
#               requestHeaderModifier = {
#                 add = [
#                   {
#                     name  = "X-Gateway-Source"
#                     value = "envoy-gateway"
#                   }
#                 ]
#               }
#             }
#           ]
#
#           backendRefs = [
#             {
#               name      = kubernetes_service.app.metadata[0].name
#               namespace = kubernetes_namespace_v1.gateway.metadata[0].name
#               port      = 80
#               weight    = 100
#             }
#           ]
#         },
#
#         # --- /* → sample-app (catch-all) ---
#         {
#           matches = [
#             {
#               path = {
#                 type  = "PathPrefix"
#                 value = "/"
#               }
#             }
#           ]
#
#           backendRefs = [
#             {
#               name      = kubernetes_service.app.metadata[0].name
#               namespace = kubernetes_namespace_v1.gateway.metadata[0].name
#               port      = 80
#               weight    = 100
#             }
#           ]
#         }
#       ]
#     }
#   }
# }
#
# # -------------------------------------------------------------------
# # ReferenceGrant
# # Allows the Gateway (in gateway-system) to reference backend
# # Services in the same namespace.
# # -------------------------------------------------------------------
# # resource "kubernetes_manifest" "reference_grant" {
# #   manifest = {
# #     apiVersion = "gateway.networking.k8s.io/v1beta1"
# #     kind       = "ReferenceGrant"
# #
# #     metadata = {
# #       name      = "allow-gateway-to-app"
# #       namespace = kubernetes_namespace_v1.gateway.metadata[0].name
# #     }
# #
# #     spec = {
# #       from = [
# #         {
# #           group     = "gateway.networking.k8s.io"
# #           kind      = "Gateway"
# #           namespace = kubernetes_namespace_v1.gateway.metadata[0].name
# #         }
# #       ]
# #
# #       to = [
# #         {
# #           group = ""
# #           kind  = "Service"
# #         }
# #       ]
# #     }
# #   }
# # }
