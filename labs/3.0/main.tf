provider "azurerm" {
  version = "~> 1.30.1"
}

resource "azurerm_resource_group" "lab" {
  name     = "lab-3-0"
  location = "northeurope"
}