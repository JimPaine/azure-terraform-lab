provider "azurerm" {
  version = "~> 1.30.1"
}

provider "random" {
  version = "~> 2.1"
}

resource "random_id" "lab" {
  keepers = {
    resource_group  = "${var.resource_group_name}"
  }

  byte_length = 2
}

resource "azurerm_app_service_plan" "lab" {
  name                = "lab-plan"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.resource_group_location}"

  kind = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_storage_account" "lab" {
  name                     = "lab${random_id.lab.dec}store"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.resource_group_location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "lab" {
  name                      = "lab${random_id.lab.dec}"
  resource_group_name       = "${var.resource_group_name}"
  location                  = "${var.resource_group_location}"
  app_service_plan_id       = "${azurerm_app_service_plan.lab.id}"
  storage_connection_string = "${azurerm_storage_account.lab.primary_connection_string}"
  
  version = "~2"
}