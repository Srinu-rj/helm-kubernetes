resource "azurerm_lb" "aks_load_balancer" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.aks_rg_demo.location
  resource_group_name = azurerm_resource_group.aks_rg_demo.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip_aks.id
  }
}

resource "azurerm_lb_backend_address_pool" "aks_load_balancer_pool" {
  loadbalancer_id = azurerm_lb.aks_load_balancer.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "aks_load_balancer_pool_address" {
  name                                = "address1"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.aks_load_balancer_pool.id
  backend_address_ip_configuration_id = azurerm_lb.aks_load_balancer.frontend_ip_configuration[0].id
}

resource "azurerm_lb_nat_pool" "aks_lb_nat_pool" {
  resource_group_name            = azurerm_resource_group.aks_rg_demo.name
  loadbalancer_id                = azurerm_lb.aks_load_balancer.id
  name                           = "SampleApplicationPool"
  protocol                       = "Tcp"
  frontend_port_start            = 80
  frontend_port_end              = 81
  backend_port                   = 8080
  frontend_ip_configuration_name = "PublicIPAddress"
}
resource "azurerm_lb_outbound_rule" "aks_lb_outbound_rule" {
  name                    = "OutboundRule"
  loadbalancer_id         = azurerm_lb.aks_load_balancer.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.aks_load_balancer_pool.id

  frontend_ip_configuration {
    name = "PublicIPAddress"
  }
}
