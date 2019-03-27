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