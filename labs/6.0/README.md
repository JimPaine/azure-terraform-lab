[![infra as code with Terraform](/docs/images/banner.png)](/README.md)

# Managed Service Identity

We have now covered all the basics for getting up and running with Terraform, so lets now take a look at what else we can use it for. As I have probably mentioned a view times now, I like to refer to everything we are working through in this lab as "environment as code" rather than "infra as code". We have already seen how we can use it for configuration as well as resources, so lets now take a look at how we can use it implement an identity for our app, to use against another service such as Key Vault.

## Step 1 - Create the identity

Let's start by adding an Azure Function to our environment in /env this is no different to what we did in the first lab, so refer back to that lab for reference.

What we didn't do in the first lab was add an identity for the resource. To add a managed service identity to the function add the following to the route of the function resource.

```
identity {
  type = "SystemAssigned"
}
```
## Step 2 - Add a second resource

Currently in Azure, Managed Service Identity is supported by a range or resources, including:

- VMs
- Functions
- App Service
- Key Vault
- Azure SQL

For this example we will use Key Vault as this is a good go to for when you want to work with resources that don't support MSI, as you can store say connection string or secrets inside Key Vault then retrieve them through MSI.

So let's get started by adding an Azure Key vault.

```
resource "azurerm_key_vault" "lab" {
  name                = "${var.resource_name}${random_id.lab.dec}vault"
  location            = "${azurerm_resource_group.lab.location}"
  resource_group_name = "${azurerm_resource_group.lab.name}"
  tenant_id           = "${data.azurerm_client_config.lab.tenant_id}"

  sku {
    name = "standard"
  }
}
```

## Step 3 - Access policies

Once you have created the a Key Vault we can start to add access policies. The first one create a policy that allows Terraform to manage the secrets in key vault.

```
resource "azurerm_key_vault_access_policy" "terraformclient" {
  vault_name          = "${azurerm_key_vault.lab.name}"
  resource_group_name = "${azurerm_key_vault.lab.resource_group_name}"

  tenant_id = "${data.azurerm_client_config.lab.tenant_id}"
  object_id = "${data.azurerm_client_config.lab.service_principal_object_id}"

  key_permissions = []

  secret_permissions = [
      "list",
      "set",
      "get",
      "delete"
    ]
}
```

Now we can create a second policy which allows our function to have read only access.

```
resource "azurerm_key_vault_access_policy" "functionmsi" {
  vault_name          = "${azurerm_key_vault.lab.name}"
  resource_group_name = "${azurerm_key_vault.lab.resource_group_name}"

  tenant_id = "${data.azurerm_client_config.lab.tenant_id}"
  object_id = "${azurerm_function_app.lab.identity.0.principal_id}"

  key_permissions = []

  secret_permissions = [
    "get",
    "list",
  ]
}
```
# Next Step
[7.0 Using ARM to fill the Gaps](../7.0)