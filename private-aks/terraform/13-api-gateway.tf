# resource "kubernetes_manifest" "gateway_class" {
#   manifest = {
#     apiVersion = "gateway.networking.k8s.io/v1"
#     kind       = "GatewayClass"
#
#     metadata = {
#       name = "my-gateway-class"
#     }
#
#     spec = {
#       controllerName = "example.com/gateway-controller"
#     }
#   }
# }
#
# resource "kubernetes_manifest" "gateway" {
#   manifest = {
#     apiVersion = "gateway.networking.k8s.io/v1"
#     kind       = "Gateway"
#
#     metadata = {
#       name      = "my-gateway"
#       namespace = "default"
#     }
#
#     spec = {
#       gatewayClassName = kubernetes_manifest.gateway_class.manifest.metadata.name
#
#       listeners = [
#         {
#           name     = "http"
#           port     = 80
#           protocol = "HTTP"
#           allowedRoutes = {
#             namespaces = {
#               from = "Same"
#             }
#           }
#         },
#         {
#           name     = "https"
#           port     = 443
#           protocol = "HTTPS"
#           tls = {
#             mode = "Terminate"
#             certificateRefs = [
#               {
#                 name = "my-tls-secret"
#               }
#             ]
#           }
#           allowedRoutes = {
#             namespaces = {
#               from = "All"
#             }
#           }
#         }
#       ]
#     }
#   }
# }
#
# resource "kubernetes_manifest" "http_route" {
#   manifest = {
#     apiVersion = "gateway.networking.k8s.io/v1"
#     kind       = "HTTPRoute"
#
#     metadata = {
#       name      = "my-app-route"
#       namespace = "default"
#     }
#
#     spec = {
#       parentRefs = [
#         {
#           name = kubernetes_manifest.gateway.manifest.metadata.name
#         }
#       ]
#
#       hostnames = ["app.example.com"]
#
#       rules = [
#         {
#           matches = [
#             {
#               path = {
#                 type  = "PathPrefix"
#                 value = "/api"
#               }
#             }
#           ]
#           backendRefs = [
#             {
#               name = "api-service"
#               port = 8080
#             }
#           ]
#         },
#         {
#           matches = [
#             {
#               path = {
#                 type  = "PathPrefix"
#                 value = "/"
#               }
#             }
#           ]
#           backendRefs = [
#             {
#               name   = "frontend-service"
#               port   = 3000
#               weight = 100
#             }
#           ]
#         }
#       ]
#     }
#   }
# }
#
# # resource "kubernetes_manifest" "canary_route" {
# #   manifest = {
# #     apiVersion = "gateway.networking.k8s.io/v1"
# #     kind       = "HTTPRoute"
# #
# #     metadata = {
# #       name      = "canary-route"
# #       namespace = "default"
# #     }
# #
# #     spec = {
# #       parentRefs = [{ name = "my-gateway" }]
# #       hostnames  = ["app.example.com"]
# #
# #       rules = [
# #         {
# #           backendRefs = [
# #             {
# #               name   = "app-stable"
# #               port   = 80
# #               weight = 90
# #             },
# #             {
# #               name   = "app-canary"
# #               port   = 80
# #               weight = 10
# #             }
# #           ]
# #         }
# #       ]
# #     }
# #   }
# # }