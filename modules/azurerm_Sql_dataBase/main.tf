resource "azurerm_mssql_database" "example" {
  name        = var.name
  server_id   = var.server_id   # server_id will come from module input
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"

  }
  

