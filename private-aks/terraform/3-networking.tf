resource "azurerm_virtual_network" "aks_vnet_demo" {
  name                = "main"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.aks_rg_demo.name
  location            = azurerm_resource_group.aks_rg_demo.location
  dns_servers         = ["168.63.129.16"]

  tags = {
    env = local.env
  }
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  address_prefixes     = ["10.0.0.0/19"]
  resource_group_name  = azurerm_resource_group.aks_rg_demo.name
  virtual_network_name = azurerm_virtual_network.aks_vnet_demo.name
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  address_prefixes     = ["10.0.32.0/19"]
  resource_group_name  = azurerm_resource_group.aks_rg_demo.name
  virtual_network_name = azurerm_virtual_network.aks_vnet_demo.name
}


resource "azurerm_public_ip" "public_ip_aks" {
  name                = "examplepip"
  location            = azurerm_resource_group.aks_rg_demo.location
  resource_group_name = azurerm_resource_group.aks_rg_demo.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# resource "azurerm_nat_gateway" "nat_gate_way" {
#   name                    = "nat-gateway"
#   location                = azurerm_resource_group.aks_rg_demo.location
#   resource_group_name     = azurerm_resource_group.aks_rg_demo.name
#   sku_name                = "Standard"
#   idle_timeout_in_minutes = 10
#   # zones                   = ["1"]
# }
#
# resource "azurerm_nat_gateway_public_ip_association" "nat_ip_association" {
#   nat_gateway_id       = azurerm_nat_gateway.nat_gate_way.id
#   public_ip_address_id = azurerm_public_ip.public_ip_aks.id
# }
#
# resource "azurerm_network_interface" "network_inc" {
#   name                = "inc"
#   location            = azurerm_resource_group.aks_rg_demo.location
#   resource_group_name = azurerm_resource_group.aks_rg_demo.name
#
#   ip_configuration {
#     name                          = "internal"
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = azurerm_subnet.aks_subnet.id
#   }
# }
# resource "azurerm_network_security_group" "network_security_group" {
#   name                = "security_group"
#   location            = azurerm_resource_group.aks_rg_demo.location
#   resource_group_name = azurerm_resource_group.aks_rg_demo.name
# }
#
# resource "azurerm_network_security_rule" "network_security_group_rule" {
#   name                        = "ssh_test"
#   direction                   = "Outbound"
#   access                      = "Allow"
#   network_security_group_name = azurerm_network_security_group.network_security_group.id
#   priority                    = 100
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name = azurerm_resource_group.aks_rg_demo.name
# }
#
# resource "azurerm_subnet_network_security_group_association" "sub_security_grp_association" {
#   network_security_group_id = azurerm_network_security_group.network_security_group.id
#   subnet_id                 = azurerm_subnet.aks_subnet.id
# }
#
# resource "azurerm_bastion_host" "bastion_host_aks" {
#   name                = "bastion_host_aks"
#   location            = local.env
#   resource_group_name = azurerm_resource_group.aks_rg_demo.name
#
#   ip_configuration {
#     name                 = "configuration"
#     public_ip_address_id = azurerm_public_ip.public_ip_aks.id
#     subnet_id            = azurerm_subnet.aks_subnet.id
#   }
# }
