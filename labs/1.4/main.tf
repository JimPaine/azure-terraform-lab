provider "azurerm" {
  version = "~> 1.30.1"
}

provider "random" {
  version = "~> 2.1"
}
resource "azurerm_resource_group" "lab" {
  name     = "lab-1-4"
  location = "northeurope"
}

resource "random_id" "lab" {
  keepers = {
    resource_group = "${azurerm_resource_group.lab.name}"
  }

  byte_length = 2
}

resource "azurerm_app_service_plan" "lab" {
  name                = "lab-plan"
  location            = "${azurerm_resource_group.lab.location}"
  resource_group_name = "${azurerm_resource_group.lab.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_storage_account" "lab" {
  name                     = "lab${random_id.lab.dec}store"
  resource_group_name      = "${azurerm_resource_group.lab.name}"
  location                 = "${azurerm_resource_group.lab.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "lab" {
  name                      = "lab${random_id.lab.dec}demo"
  location                  = "${azurerm_resource_group.lab.location}"
  resource_group_name       = "${azurerm_resource_group.lab.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.lab.id}"
  storage_connection_string = "${azurerm_storage_account.lab.primary_connection_string}"
  
  version = "~2"

  app_settings = {
  }
}