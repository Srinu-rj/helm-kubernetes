# ============================================================
# NAT GATEWAY — Outbound Traffic Control
# ============================================================
resource "azurerm_public_ip" "nat_pip" {
  name                = "pip-nat-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }
}

resource "azurerm_nat_gateway" "nat_gw" {
  name                    = "nat-gw-private-aks"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }
}

resource "azurerm_nat_gateway_public_ip_association" "nat_pip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

# ✅ Associate to AKS subnets
resource "azurerm_subnet_nat_gateway_association" "system_nat" {
  subnet_id      = azurerm_subnet.aks_system_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}

resource "azurerm_subnet_nat_gateway_association" "user_nat" {
  subnet_id      = azurerm_subnet.aks_user_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}

resource "azurerm_subnet_nat_gateway_association" "pod_nat" {
  subnet_id      = azurerm_subnet.aks_pod_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}