module "resource_group" {
  source                  = "../modules/azurerm_resource_group"
  resource_group_name     = "rg-todoapp1"
  resource_group_location = "East US"
}

module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "../modules/azurerm_virtual_network"

  virtual_network_name     = "vnet-todoapp1"
  virtual_network_location = "East US"
  resource_group_name      = "rg-todoapp1"
  address_space            = ["10.0.0.0/16"]
}

module "frontend_subnet" {
  depends_on = [module.virtual_network]
  source     = "../modules/azurerm_subnet"

  resource_group_name  = "rg-todoapp1"
  virtual_network_name = "vnet-todoapp1"
  subnet_name          = "frontend-subnet"
  address_prefixes     = ["10.0.1.0/24"]
}

module "backend_subnet" {
  depends_on = [module.virtual_network]
  source     = "../modules/azurerm_subnet"

  resource_group_name  = "rg-todoapp1"
  virtual_network_name = "vnet-todoapp1"
  subnet_name          = "backend-subnet"
  address_prefixes     = ["10.0.2.0/24"]
}

# module "public_ip_frontend" {
#   source              = "../modules/azurerm_public_ip"
#   depends_on = [
#     module.resource_group
#   ]
#   public_ip_name      = "pip-todoapp-frontend"
#   resource_group_name = "rg-todoapp1"
#   location            = "East US"
#   allocation_method   = "Static"
# }


# module "frontend_vm2" {
#   depends_on = [module.frontend_subnet, module.key_vault, module.vm_username, module.vm_password, module.public_ip_frontend]
#   source     = "../modules/azurerm_virtual_machine"

#   resource_group_name  = "rg-todoapp1"
#   location             = "East US"
#   vm_name              = "vm-frontend2"
#   vm_size              = "Standard_B1ms"
#   admin_username       = "devopsadmin"
#   image_publisher      = "Canonical"
#   image_offer          = "0001-com-ubuntu-server-focal"
#   image_sku            = "20_04-lts"
#   image_version        = "latest"
#   nic_name             = "nic-vm-frontend2"
#   frontend_ip_name     = "pip-todoapp-frontend"
#   vnet_name            = "vnet-todoapp1"
#   frontend_subnet_name = "frontend-subnet"
#   key_vault_name       = "sonamkitijori2"
#   username_secret_name = "vm-username"
#   password_secret_name = "vm-password"
# }


module "public_ip_backend" {
  depends_on          = [module.resource_group]
  source              = "../modules/azurerm_public_ip"
  public_ip_name      = "pip-todoapp_backend"
  resource_group_name = "rg-todoapp"
  location            = "centralindia"
  allocation_method   = "Static"
}

module "backend_vm" {
  depends_on = [module.frontend_subnet, module.key_vault, module.vm_username, module.vm_password, module.public_ip_frontend]
  source     = "../modules/azurerm_virtual_machine"

  resource_group_name  = "rg-todoapp1"
  location             = "East US"
  vm_name              = "vm-backend2"
  vm_size              = "Standard_B1ms"
  admin_username       = "devopsadmin"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-focal"
  image_sku            = "20_04-lts"
  image_version        = "latest"
  nic_name             = "nic-vm-backend2"
  backend_ip_name     = "pip-todoapp-backend"
  vnet_name            = "vnet-todoapp1"
 frontend_subnet_name =  "backend-subnet"
  key_vault_name       = "sonamkitijori2"
  username_secret_name = "vm-username"
  password_secret_name = "vm-password"
}

# module sql_server {
#   source = "../modules/azurerm_sql_server"
#   depends_on = [
#     module.resource_group
#   ]
#   resource_group_name = "rg-todoapp"
#   location            = "southindia"
#   sql_server_name     = "todoappsqlserver001"
#   sql_version        = "12.0"
#   administrator_login = "sqladmin"
#   administrator_login_password = "P@ssword1234"
# }

# module "sql_database" {
#   source     = "../modules/azurerm_sql_database"
#   name       = "todoappdb"   
#   server_id  = "/subscriptions/b6571c78-f766-4999-8358-e9602abe50cf/resourceGroups/rg-todoapp/providers/Microsoft.Sql/servers/todoappsqlserver001"

#   depends_on = [module.sql_server]
# }

module "key_vault" {
  source              = "../modules/azurerm_key_vault"
  key_vault_name      = "sonamkitijori12"
  location            = "East US"
  resource_group_name = "rg-todoapp1"
}

module "vm_password" {
  source              = "../modules/azurerm_key_vault_secret"
  depends_on          = [module.key_vault]
  key_vault_name      = "sonamkitijori12"
  resource_group_name = "rg-todoapp1"
  secret_name         = "vm-password"
  secret_value        = "P@ssw01rd@123"
}

module "vm_username" {
  source              = "../modules/azurerm_key_vault_secret"
  depends_on          = [module.key_vault]
  key_vault_name      = "sonamkitijori12"
  resource_group_name = "rg-todoapp1"
  secret_name         = "vm-username"
  secret_value        = "devopsadmin"
}

