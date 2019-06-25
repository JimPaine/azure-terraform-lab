[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Remote state

As well as using a service principal to run Terraform, which allows us to run it in an automated fashion, we also need to store and manage the state in acentral place, which allows multiple people and or teams to work together across environments.

## Step 1 - Adding a storage account

To do this we need to create a storage account, add the below to the previous main.tf file, this will allow us to store the state file.

```
resource "azurerm_storage_account" "lab" {
  name                     = "terraformstate${random_id.lab.dec}"
  resource_group_name      = "${azurerm_resource_group.lab.name}"
  location                 = "${azurerm_resource_group.lab.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "lab" {
  name                  = "state"
  resource_group_name   = "${azurerm_resource_group.lab.name}"
  storage_account_name  = "${azurerm_storage_account.lab.name}"
  container_access_type = "private"
}
```

## Step 2 - Next put the values in a key vault.

```
resource "azurerm_key_vault_secret" "storage-account" {
    name = "storage-account"
    value = "${azurerm_storage_account.lab.name}"
    vault_uri = "${azurerm_key_vault.lab.vault_uri}"
}

resource "azurerm_key_vault_secret" "container-name" {
    name = "container-name"
    value = "${azurerm_storage_container.lab.name}"
    vault_uri = "${azurerm_key_vault.lab.vault_uri}"
}

resource "azurerm_key_vault_secret" "access-key" {
    name = "access-key"
    value = "${azurerm_storage_account.lab.primary_access_key}"
    vault_uri = "${azurerm_key_vault.lab.vault_uri}"
}


resource "azurerm_key_vault_secret" "resource-group" {
    name = "resource-group"
    value = "${azurerm_resource_group.lab.name}"
    vault_uri = "${azurerm_key_vault.lab.vault_uri}"
}
```

## Step 3 - (Optionally add the values to the output)

```
output "storage-account" {
    value = "${azurerm_storage_account.lab.name}"
}

output "container-name" {
    value = "${azurerm_storage_container.lab.name}"
}

output "access-key" {
    value = "${azurerm_storage_account.lab.primary_access_key}"
}

output "resource_group" {
  value = "${azurerm_resource_group.lab.name}"
}
```

## Step 4 - Setting the provider.

To run the provider with the service principal we need to update the provider details in main.tf. Below is an example of what the provider should look like.

```
provider "azurerm" {
  version = "~> 1.30.1"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}
```

## Step 5 - Setting the backend

Add a new file called backend.tf and add the following.

```
terraform {
  backend "azurerm" {
    #example properties
    #resource_group_name  = ""
    #storage_account_name = ""
    #container_name       = ""
    #key                  = ""
    #access_key           = ""
  }
}
```

You will notice that the values are all commented out, this is because we don't want these values set in source control and passed in when we execute the script.

## Step 6 - Running it!

Now to run it we are going to run the "terraform init" command and pass in the values to use for the backend. This will set were terraform stores and uses the statefile.

```
terraform init \
       -backend-config="resource_group_name=[resource-group]" \
       -backend-config="storage_account_name=[storage-account]" \
       -backend-config="container_name=[container-name]" \
       -backend-config="key=demo.tfstate" \
       -backend-config="access_key=[access-key]"
```

Now when we want to apply our configuration we can call the apply, just like below.

```
terraform apply -var="user=[azurelogin@email.com]"
```

What this will do now is create a storage account and give our Terraform client access to the BLOB storage account.

## Step 7 - Let's take a look at what it has created for us.


# Next Step
[5.0 Variable Groups](../5.0)
