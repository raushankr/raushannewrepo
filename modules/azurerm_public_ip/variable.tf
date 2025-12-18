variable "public_ip_name" {
  description = "Configuration for the Azure Public IP address."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group in which to create the public IP."
  type        = string
}
variable "location" {
  description = "The Azure region where the public IP will be created."
  type        = string
}
variable "allocation_method" {  
  description = "The allocation method for the public IP address (Static or Dynamic)."
  type        = string
}
