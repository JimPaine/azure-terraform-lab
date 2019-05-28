provider "azurerm" {
  subscription_id = "${var.subscription-id}"
  version         = "~> 1.23"
  client_id       = "${var.client-id}"
  client_secret   = "${var.client-secret}"
  tenant_id       = "${var.tenant-id}"
}

provider "azuread" {
  version = "~> 0.2"
}


provider "random" {
  version = "~> 1.3"
}