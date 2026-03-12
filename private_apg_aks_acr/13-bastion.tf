# ============================================================
# AZURE BASTION
# ============================================================
resource "azurerm_public_ip" "bastion_pip" {
  name                = "pip-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = { environment = "prod", managed_by = "terraform" }
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-private-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  tunneling_enabled   = true
  file_copy_enabled   = true
  ip_connect_enabled  = true
  copy_paste_enabled  = true

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  tags = { environment = "prod", managed_by = "terraform" }
}