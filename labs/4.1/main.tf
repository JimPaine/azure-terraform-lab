provider "azurerm" {
  version = "1.23"
}

provider "azuread" {
  version = "0.2"
}


provider "random" {
  version = "1.3"
}

data "azurerm_resource_group" "lab" {
  name     = "lab-core" 
}

resource "random_id" "lab" {
  keepers = {
    resource_group = "${data.azurerm_resource_group.lab.name}"
  }

  byte_length = 2
}

data "azurerm_client_config" "lab" {}

resource "azurerm_storage_account" "lab" {
  name                     = "terraformstate${random_id.lab.dec}"
  resource_group_name      = "${data.azurerm_resource_group.lab.name}"
  location                 = "${data.azurerm_resource_group.lab.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "lab" {
  name                  = "state"
  resource_group_name   = "${data.azurerm_resource_group.lab.name}"
  storage_account_name  = "${azurerm_storage_account.lab.name}"
  container_access_type = "private"
}

data "azuread_user" "lab" {
  user_principal_name = "${var.user}"
}

resource "azurerm_key_vault" "lab" {
  name                = "state${random_id.lab.dec}vault"
  location            = "${data.azurerm_resource_group.lab.location}"
  resource_group_name = "${data.azurerm_resource_group.lab.name}"
  tenant_id           = "${data.azurerm_client_config.lab.tenant_id}"

  sku {
    name = "standard"
  }

  access_policy {
    tenant_id = "${data.azurerm_client_config.lab.tenant_id}"
    object_id = "${data.azuread_user.lab.id}"

    key_permissions = []

    secret_permissions = [
      "list",
      "set",
      "get",
    ]
  }
}

output "resource-group" {
    value = "${data.azurerm_resource_group.lab.name}"
}

resource "azurerm_key_vault_secret" "resource-group" {
    name = "resource-group"
    value = "${data.azurerm_resource_group.lab.name}"
    vault_uri = "${azurerm_key_vault.lab.vault_uri}"
}

output "storage-account" {
    value = "${azurerm_storage_account.lab.name}"
}

resource "azurerm_key_vault_secret" "storage-account" {
    name = "storage-account"
    value = "${azurerm_storage_account.lab.name}"
    vault_uri = "${azurerm_key_vault.lab.vault_uri}"
}

output "container-name" {
    value = "${azurerm_storage_container.lab.name}"
}

resource "azurerm_key_vault_secret" "container-name" {
    name = "container-name"
    value = "${azurerm_storage_container.lab.name}"
    vault_uri = "${azurerm_key_vault.lab.vault_uri}"
}

output "access-key" {
    value = "${azurerm_storage_account.lab.primary_access_key}"
}

resource "azurerm_key_vault_secret" "access-key" {
    name = "access-key"
    value = "${azurerm_storage_account.lab.primary_access_key}"
    vault_uri = "${azurerm_key_vault.lab.vault_uri}"
}