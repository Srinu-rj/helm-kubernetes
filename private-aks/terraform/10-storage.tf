# resource "random_integer" "random_rg" {
#   min = 10000
#   max = 5000000
# }
#
# resource "azurerm_storage_account" "storage_account" {
#   name                     = "devtest${random_integer.random_rg.result}"
#   resource_group_name      = azurerm_resource_group.aks_rg_demo.name
#   location                 = azurerm_resource_group.aks_rg_demo.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#
# }
# resource "azurerm_storage_container" "storage_container" {
#   name                 = "storage_container_aks"
#   storage_account_name = azurerm_storage_account.storage_account.name
# }
# resource "azurerm_role_assignment" "dev_test" {
#   scope                = azurerm_storage_account.storage_account.id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
# }
