# ============================================================
# PUBLIC IP — Application Gateway
# ============================================================
resource "azurerm_public_ip" "appgw_pip" {
  name                = "pip-appgw-private-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  domain_name_label   = "appgw-private-aks-0208"

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }
}

# ============================================================
# WAF POLICY
# ============================================================
resource "azurerm_web_application_firewall_policy" "waf" {
  name                = "waf-policy-private-aks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }

    managed_rule_set {
      type    = "Microsoft_BotManagerRuleSet"
      version = "0.1"
    }
  }

  custom_rules {
    name      = "BlockSQLInjection"
    priority  = 1
    rule_type = "MatchRule"
    action    = "Block"

    match_conditions {
      match_variables { variable_name = "QueryString" }
      operator           = "Contains"
      negation_condition = false
      match_values       = ["DROP TABLE", "1=1", "UNION SELECT"]
      transforms         = ["HtmlEntityDecode"]
    }
  }

  custom_rules {
    name                 = "RateLimitRule"
    priority             = 2
    rule_type            = "RateLimitRule"
    action               = "Block"
    rate_limit_duration  = "OneMin"
    rate_limit_threshold = 1000
    group_rate_limit_by  = "ClientAddr"

    match_conditions {
      match_variables { variable_name = "RemoteAddr" }
      operator           = "IPMatch"
      negation_condition = true
      match_values       = ["10.0.0.0/8"]
    }
  }

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }
}

# ============================================================
# APPLICATION GATEWAY
# ============================================================
locals {
  frontend_ip_config   = "appgw-frontend-ip"
  frontend_port_http   = "appgw-port-80"
  frontend_port_https  = "appgw-port-443"
  backend_pool_name    = "aks-backend-pool"
  http_setting_name    = "aks-http-setting"
  http_listener_name   = "http-listener"
  https_listener_name  = "https-listener"
  redirect_config_name = "http-to-https"
  routing_rule_http    = "rule-http-redirect"
  routing_rule_https   = "rule-https"
  probe_name           = "aks-health-probe"
  ssl_cert_name        = "appgw-ssl-cert"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "appgw-private-aks-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  zones               = ["1", "2", "3"]
  firewall_policy_id  = azurerm_web_application_firewall_policy.waf.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.appgw_identity.id]
  }

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = 2
    max_capacity = 10
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_config
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  frontend_port {
    name = local.frontend_port_http
    port = 80
  }

  frontend_port {
    name = local.frontend_port_https
    port = 443
  }

  # ✅ Backend — AKS Ingress
  backend_address_pool {
    name = local.backend_pool_name
  }

  backend_http_settings {
    name                                = local.http_setting_name
    cookie_based_affinity               = "Disabled"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 30
    pick_host_name_from_backend_address = true
    probe_name                          = local.probe_name

    connection_draining {
      enabled           = true
      drain_timeout_sec = 30
    }
  }

  # ✅ Health Probe
  probe {
    name                                      = local.probe_name
    protocol                                  = "Http"
    path                                      = "/health"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true

    match {
      status_code = ["200-399"]
    }
  }

  # ✅ HTTP Listener
  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_config
    frontend_port_name             = local.frontend_port_http
    protocol                       = "Http"
  }

  # ✅ HTTP to HTTPS Redirect
  redirect_configuration {
    name                 = local.redirect_config_name
    redirect_type        = "Permanent"
    target_listener_name = local.https_listener_name
    include_path         = true
    include_query_string = true
  }

  # ✅ HTTPS Listener
  http_listener {
    name                           = local.https_listener_name
    frontend_ip_configuration_name = local.frontend_ip_config
    frontend_port_name             = local.frontend_port_https
    protocol                       = "Https"
    ssl_certificate_name           = local.ssl_cert_name
  }

  # ✅ SSL Certificate
  ssl_certificate {
    name                = local.ssl_cert_name
    key_vault_secret_id = azurerm_key_vault_certificate.appgw_cert.secret_id
  }

  # ✅ SSL Policy
  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }

  # ✅ Routing Rules
  request_routing_rule {
    name                        = local.routing_rule_http
    rule_type                   = "Basic"
    priority                    = 100
    http_listener_name          = local.http_listener_name
    redirect_configuration_name = local.redirect_config_name
  }

  request_routing_rule {
    name                       = local.routing_rule_https
    rule_type                  = "Basic"
    priority                   = 200
    http_listener_name         = local.https_listener_name
    backend_address_pool_name  = local.backend_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  # ✅ Rewrite Rules — Security Headers
  rewrite_rule_set {
    name = "security-headers"

    rewrite_rule {
      name          = "add-security-headers"
      rule_sequence = 100

      response_header_configuration {
        header_name  = "Strict-Transport-Security"
        header_value = "max-age=31536000; includeSubDomains"
      }

      response_header_configuration {
        header_name  = "X-Content-Type-Options"
        header_value = "nosniff"
      }

      response_header_configuration {
        header_name  = "X-Frame-Options"
        header_value = "DENY"
      }

      response_header_configuration {
        header_name  = "X-XSS-Protection"
        header_value = "1; mode=block"
      }

      response_header_configuration {
        header_name  = "Server"
        header_value = ""
      }
    }
  }

  # ✅ WAF Config
  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"

    file_upload_limit_mb     = 100
    request_body_check       = true
    max_request_body_size_kb = 128
  }

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.appgw_nsg_assoc,
    azurerm_key_vault_certificate.appgw_cert
  ]
}

# ============================================================
# AppGW Identity & Certificate
# ============================================================
resource "azurerm_user_assigned_identity" "appgw_identity" {
  name                = "identity-appgw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = { environment = "prod", managed_by = "terraform" }
}

resource "azurerm_key_vault_access_policy" "appgw_kv_access" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.appgw_identity.principal_id

  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_certificate" "appgw_cert" {
  name         = "appgw-ssl-cert"
  key_vault_id = azurerm_key_vault.kv.id

  certificate_policy {
    issuer_parameters { name = "Self" }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action { action_type = "AutoRenew" }
      trigger { days_before_expiry = 30 }
    }

    secret_properties { content_type = "application/x-pkcs12" }

    x509_certificate_properties {
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]
      key_usage          = ["digitalSignature", "keyEncipherment"]
      subject            = "CN=myapp.mycompany.com"
      validity_in_months = 12

      subject_alternative_names {
        dns_names = ["myapp.mycompany.com", "api.mycompany.com"]
      }
    }
  }

  depends_on = [azurerm_key_vault_access_policy.appgw_kv_access]
}
