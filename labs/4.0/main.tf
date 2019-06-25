provider "azuread" {
  version = "~> 0.4"
}

provider "azurerm" {
  version = "~> 1.30.1"
}

provider "random" {
  version = "~> 2.1"
}

resource "azurerm_resource_group" "lab" {
  name     = "lab-core"
  location = "northeurope"    
}

resource "random_id" "lab" {
  keepers = {
    resource_group = "${azurerm_resource_group.lab.name}"
  }

  byte_length = 2
}

resource "azuread_application" "lab" {
  name                       = "terraclient${random_id.lab.dec}"
  homepage                   = "https://homepage"
  identifier_uris            = ["https://uri${random_id.lab.dec}"]
  reply_urls                 = ["https://uri${random_id.lab.dec}"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azuread_service_principal" "lab" {
  application_id = "${azuread_application.lab.application_id}"
}

resource "random_string" "lab" {
  length  = "32"
  special = true
}

resource "azuread_service_principal_password" "lab" {
  service_principal_id = "${azuread_service_principal.lab.id}"
  value                = "${random_string.lab.result}"
  end_date             = "2020-01-01T01:02:03Z"
}

data "azurerm_client_config" "lab" {}

resource "azurerm_role_assignment" "lab" {
  scope                = "/subscriptions/${data.azurerm_client_config.lab.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = "${azuread_service_principal.lab.id}"
}
data "azuread_user" "lab" {
  user_principal_name = "${var.user}"
}

resource "azurerm_key_vault" "lab" {
  name                = "vault${random_id.lab.dec}"
  location            = "${azurerm_resource_group.lab.location}"
  resource_group_name = "${azurerm_resource_group.lab.name}"
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
      "delete"
    ]
  }
}

output "client-id" {
    value = "${azuread_application.lab.application_id}"
}

resource "azurerm_key_vault_secret" "client-id" {
    name = "client-id"
    value = "${azuread_application.lab.application_id}"
    vault_uri = "${azurerm_key_vault.lab.vault_uri}"
}

output "client-secret" {
  value = "${random_string.lab.result}"
}

resource "azurerm_key_vault_secret" "client-secret" {
    name = "client-secret"
    value = "${random_string.lab.result}"
    vault_uri = "${azurerm_key_vault.lab.vault_uri}"
}

output "subscription-id" {
  value = "${data.azurerm_client_config.lab.subscription_id}"
}

resource "azurerm_key_vault_secret" "subscription-id" {
    name = "subscription-id"
    value = "${data.azurerm_client_config.lab.subscription_id}"
    vault_uri = "${azurerm_key_vault.lab.vault_uri}"
}

output "tenant-id" {
  value = "${data.azurerm_client_config.lab.tenant_id}"
}

resource "azurerm_key_vault_secret" "tenant-id" {
    name = "tenant-id"
    value = "${data.azurerm_client_config.lab.tenant_id}"
    vault_uri = "${azurerm_key_vault.lab.vault_uri}"
}