provider "azurerm" {
  subscription_id = "${var.subscription-id}"
  version         = "1.22"
  client_id       = "${var.client-id}"
  client_secret   = "${var.client-secret}"
  tenant_id       = "${var.tenant-id}"
}