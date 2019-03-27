provider "azurerm" {
  version = "1.23"
}

provider "azuread" {
  version = "0.2"
}


provider "random" {
  version = "1.3"
}

resource "azurerm_resource_group" "lab" {
  name     = "lab" 
  location = "westeurope"
}

resource "random_id" "lab" {
  keepers = {
    resource_group = "${azurerm_resource_group.lab.name}"
  }

  byte_length = 2
}