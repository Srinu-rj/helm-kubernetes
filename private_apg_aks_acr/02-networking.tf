# ============================================================
# VNET — 10.0.0.0/8
# ============================================================
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-private-aks-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/8"]
  dns_servers         = ["168.63.129.16"]

  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }
}

# ============================================================
# SUBNETS
# ============================================================

# ── AKS System Node Pool ──────────────────────────────────
resource "azurerm_subnet" "aks_system_subnet" {
  name                 = "snet-aks-system"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.240.0.0/16"]
  service_endpoints    = ["Microsoft.ContainerRegistry"]
}

# ── AKS User Node Pool ────────────────────────────────────
resource "azurerm_subnet" "aks_user_subnet" {
  name                 = "snet-aks-user"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.241.0.0/16"]
  service_endpoints    = ["Microsoft.ContainerRegistry"]
}

# ── AKS Pod Subnet ────────────────────────────────────────
resource "azurerm_subnet" "aks_pod_subnet" {
  name                 = "snet-aks-pods"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.242.0.0/16"]

  delegation {
    name = "aks-pod-delegation"
    service_delegation {
      name = "Microsoft.ContainerService/managedClusters"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

# ── AKS API Server Subnet ─────────────────────────────────
resource "azurerm_subnet" "aks_api_subnet" {
  name                 = "snet-aks-api"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.243.0.0/27"]

  delegation {
    name = "aks-api-delegation"
    service_delegation {
      name = "Microsoft.ContainerService/managedClusters"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

# ── Application Gateway Subnet ────────────────────────────
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "snet-appgw"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.243.1.0/24"]
}

# ── Private Endpoints Subnet ──────────────────────────────
resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.243.2.0/24"]
}

# ── Bastion Subnet ────────────────────────────────────────
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.243.3.0/24"]
}

# ── Jumpbox Subnet ────────────────────────────────────────
resource "azurerm_subnet" "jumpbox_subnet" {
  name                 = "snet-jumpbox"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.243.4.0/24"]
}