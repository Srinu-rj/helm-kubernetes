resource "azurerm_virtual_network" "aks_vnet_demo" {
  name                = "main"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.aks_rg_demo.name
  location            = azurerm_resource_group.aks_rg_demo.location

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

# resource "azurerm_public_ip" "public_ip" {
#   name                = "publicip"
#   location            = azurerm_resource_group.aks_rg_demo.location
#   resource_group_name = azurerm_resource_group.aks_rg_demo.name
#
#   allocation_method   = "Static"
#   sku                 = "Standard"
#
#   # zones = ["1", "2", "3"] # optional but recommended for HA
# }


# resource "azurerm_network_interface" "nic" {
#   name                = "network_interface_name"
#   location            = azurerm_resource_group.aks_rg_demo.location
#   resource_group_name = azurerm_resource_group.aks_rg_demo.name
#
#   ip_configuration {
#     name                          = "internal"
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = azurerm_subnet.subnet1.id
#     public_ip_address_id          = azurerm_public_ip.public_ip.id
#   }
# }

# resource "azurerm_nat_gateway" "nat" {
#   name                    = "nat-gateway"
#   location                = azurerm_resource_group.aks_rg_demo.location
#   resource_group_name     = azurerm_resource_group.aks_rg_demo.name
#   sku_name                = "Standard"
#   idle_timeout_in_minutes = 10
# }
#
# resource "azurerm_nat_gateway_public_ip_association" "public_ip_association" {
#   nat_gateway_id       = azurerm_nat_gateway.nat.id
#   public_ip_address_id = azurerm_public_ip.public_ip.id
# }
#
# resource "azurerm_network_security_group" "network_security_grp" {
#   name                = "acceptanceTestSecurityGroup1"
#   location            = azurerm_resource_group.aks_rg_demo.location
#   resource_group_name = azurerm_resource_group.aks_rg_demo.name
#
# }
#
# resource "azurerm_network_security_rule" "ssh_access" {
#   name                        = "allow-ssh"
#   priority                    = 1001
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "22"
#   source_address_prefix       = "*" # Replace with your trusted IP or subnet
#   destination_address_prefix  = "*"
#   network_security_group_name = azurerm_network_security_group.network_security_grp.name
#   resource_group_name         = azurerm_resource_group.aks_rg_demo.name
# }
#
# resource "azurerm_network_security_rule" "example" {
#   name                        = "test123"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.aks_rg_demo.name
#   network_security_group_name = azurerm_network_security_group.network_security_grp.name
# }
#
#
# resource "azurerm_subnet_network_security_group_association" "subnet_security_group_association" {
#   subnet_id                 = azurerm_subnet.subnet1.id
#   network_security_group_id = azurerm_network_security_group.network_security_grp.id
# }
# resource "azurerm_network_interface_security_group_association" "vnet_security_group_association" {
#   network_interface_id      = azurerm_network_interface.nic.id
#   network_security_group_id = azurerm_network_security_group.network_security_grp.id
# }

# resource "azurerm_lb" "load_balancer" {
#   name                = "example-lb"
#   sku                 = "Standard"
#   location            = azurerm_resource_group.aks_rg_demo.location
#   resource_group_name = azurerm_resource_group.aks_rg_demo.name
#
#   frontend_ip_configuration {
#     name                 = azurerm_public_ip.public_ip.name
#     public_ip_address_id = azurerm_public_ip.public_ip.id
#   }
# }



